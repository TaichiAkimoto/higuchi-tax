import Foundation
import Speech
import AVFoundation

/// 音声認識を管理するクラス
@available(iOS 16.0, macOS 10.15, *)
@MainActor
class SpeechRecognizer: ObservableObject {
    @Published var recognizedText: String = ""
    @Published var isRecording: Bool = false
    @Published var authorizationStatus: SFSpeechRecognizerAuthorizationStatus = .notDetermined
    @Published var errorMessage: String?

    private var audioEngine: AVAudioEngine?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))

    // MARK: - Authorization

    /// 音声認識とマイクの権限をリクエスト
    func requestAuthorization() async {
        let speechStatus = await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status)
            }
        }

        authorizationStatus = speechStatus

        // マイク権限もリクエスト（iOS専用）
        #if os(iOS)
        if speechStatus == .authorized {
            let microphoneStatus = await withCheckedContinuation { continuation in
                AVAudioSession.sharedInstance().requestRecordPermission { granted in
                    continuation.resume(returning: granted)
                }
            }
            if !microphoneStatus {
                errorMessage = "マイクへのアクセスが拒否されました"
            }
        }
        #endif
    }

    // MARK: - Recording Control

    /// 音声認識を開始
    func startRecording() throws {
        // 既存のタスクをキャンセル
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }

        // オーディオセッションの設定（iOS専用）
        #if os(iOS)
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        #endif

        // 認識リクエストの作成
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        guard let recognitionRequest = recognitionRequest else {
            throw RecognizerError.nilRecognitionRequest
        }

        recognitionRequest.shouldReportPartialResults = true
        recognitionRequest.requiresOnDeviceRecognition = false

        // オーディオエンジンの設定
        audioEngine = AVAudioEngine()

        guard let audioEngine = audioEngine else {
            throw RecognizerError.nilAudioEngine
        }

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()

        // 認識タスクの開始
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }

            if let result = result {
                Task { @MainActor in
                    self.recognizedText = result.bestTranscription.formattedString
                }
            }

            if error != nil || result?.isFinal == true {
                Task { @MainActor in
                    self.stopRecording()
                }
            }
        }

        isRecording = true
        errorMessage = nil
    }

    /// 音声認識を停止
    func stopRecording() {
        audioEngine?.stop()
        audioEngine?.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()

        recognitionRequest = nil
        recognitionTask = nil
        audioEngine = nil
        isRecording = false
    }

    /// 認識結果をリセット
    func reset() {
        recognizedText = ""
        errorMessage = nil
    }
}

// MARK: - Errors

enum RecognizerError: Error {
    case nilRecognitionRequest
    case nilAudioEngine
    case notAuthorized
}
