import SwiftUI
import Lottie

@available(iOS 16.0, macOS 12.0, *)
struct TaskInputView: View {
    @ObservedObject var viewModel: AppViewModel
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State private var taskText: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 32) {
            // タイトル
            VStack(spacing: 16) {
                Text("📝")
                    .font(.system(size: 64))

                Text("何がめんどいですか？")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.slate900)
                    .multilineTextAlignment(.center)

                Text("やりたくないことを\n教えてください")
                    .font(.system(size: 16))
                    .foregroundColor(.slate600)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.top, 48)

            Spacer()

            // 入力エリア
            VStack(spacing: 16) {
                // テキスト入力
                ZStack(alignment: .topLeading) {
                    // Placeholder
                    if taskText.isEmpty {
                        Text("例: 封筒を開ける")
                            .font(.system(size: 18))
                            .foregroundColor(.slate400)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .allowsHitTesting(false)
                    }

                    // Multi-line text input
                    TextEditor(text: $taskText)
                        .font(.system(size: 18))
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .frame(minHeight: 56, maxHeight: 120)
                }
                .padding(16)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.slate300, lineWidth: 1)
                )
                .disabled(isLoading)

                // 音声入力ボタン
                Button(action: handleVoiceInput) {
                    HStack(spacing: 8) {
                        Image(systemName: speechRecognizer.isRecording ? "mic.fill" : "mic")
                            .foregroundColor(speechRecognizer.isRecording ? .red : .indigo600)
                            .font(.system(size: 18))
                            .scaleEffect(speechRecognizer.isRecording ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: speechRecognizer.isRecording)

                        Text(speechRecognizer.isRecording ? "録音中...タップで停止" : "🎤 音声で入力")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(speechRecognizer.isRecording ? .red : .indigo600)
                    }
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(speechRecognizer.isRecording ? Color.red.opacity(0.1) : Color.indigo50)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(speechRecognizer.isRecording ? Color.red : Color.indigo300, lineWidth: 1)
                    )
                }
                .disabled(isLoading || speechRecognizer.authorizationStatus == .denied)

                // エラーメッセージ
                if let error = errorMessage {
                    Text(error)
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
            }

            Spacer()

            // ボタン
            VStack(spacing: 12) {
                if isLoading {
                    VStack(spacing: 24) {
                        // Lottieアニメーション
                        LottieView(animation: .named("loading-animation"))
                            .playing(loopMode: .loop)
                            .frame(width: 200, height: 200)

                        // ローディングテキスト
                        Text("AI が考え中...")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.slate600)

                        Text("マイクロステップを作成しています")
                            .font(.system(size: 14))
                            .foregroundColor(.slate500)
                    }
                } else {
                    PrimaryButton("次へ", variant: .primary) {
                        handleSubmit()
                    }
                    .disabled(taskText.trimmingCharacters(in: .whitespaces).isEmpty)
                    .opacity(taskText.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1.0)
                }

                PrimaryButton("戻る", variant: .outline) {
                    viewModel.stage = .start
                }
            }
            .padding(.bottom, 32)
        }
        .padding(.horizontal, 16)
        .onChange(of: speechRecognizer.recognizedText) { newValue in
            if !newValue.isEmpty && !speechRecognizer.isRecording {
                taskText = newValue
            }
        }
    }

    // MARK: - Actions

    private func handleVoiceInput() {
        if speechRecognizer.isRecording {
            speechRecognizer.stopRecording()
        } else {
            // 許可状態をチェック
            switch speechRecognizer.authorizationStatus {
            case .notDetermined:
                // 初回タップ時: 許可をリクエスト
                Task {
                    await speechRecognizer.requestAuthorization()
                    // 許可が得られたら録音開始
                    if speechRecognizer.authorizationStatus == .authorized {
                        do {
                            try speechRecognizer.startRecording()
                        } catch {
                            errorMessage = "音声認識を開始できませんでした"
                        }
                    } else if speechRecognizer.authorizationStatus == .denied {
                        errorMessage = "音声認識の使用が許可されていません。設定から許可してください。"
                    }
                }
            case .authorized:
                // 既に許可済み: 録音開始
                do {
                    try speechRecognizer.startRecording()
                } catch {
                    errorMessage = "音声認識を開始できませんでした"
                }
            case .denied, .restricted:
                // 許可が拒否されている
                errorMessage = "音声認識の使用が許可されていません。設定から許可してください。"
            @unknown default:
                errorMessage = "音声認識を開始できませんでした"
            }
        }
    }

    private func handleSubmit() {
        let trimmedTask = taskText.trimmingCharacters(in: .whitespaces)
        guard !trimmedTask.isEmpty else { return }

        isLoading = true
        errorMessage = nil
        Task {
            do {
                try await viewModel.generateSteps(task: trimmedTask)
                viewModel.nextStage()
            } catch {
                print("❌ Error in handleSubmit: \(error)")
                if let nsError = error as NSError? {
                    print("   Domain: \(nsError.domain)")
                    print("   Code: \(nsError.code)")
                    print("   UserInfo: \(nsError.userInfo)")
                }
                errorMessage = "エラー: \(error.localizedDescription)"
            }
            isLoading = false
        }
    }
}

// MARK: - Preview

#if DEBUG
@available(iOS 16.0, macOS 14.0, *)
#Preview {
    TaskInputView(viewModel: AppViewModel(authManager: AuthManager()))
}
#endif
