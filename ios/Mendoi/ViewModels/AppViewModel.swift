import Foundation

/// アプリ全体の状態を管理するViewModel
@available(iOS 16.0, macOS 12.0, *)
@MainActor
class AppViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var stage: AppStage = .start
    @Published var steps: [MicroStep] = []
    @Published var currentStepIndex: Int = 0
    @Published var isLoading: Bool = false
    @Published var encouragement: String?

    // MARK: - Dependencies

    private let apiClient: APIClient
    private let authManager: AuthManager

    // MARK: - Initialization

    init(apiClient: APIClient = APIClient(baseURL: "https://mendoi-api-glhnu2cdda-an.a.run.app"), authManager: AuthManager) {
        self.apiClient = apiClient
        self.authManager = authManager

        // 匿名ログインを開始
        Task {
            do {
                try await authManager.signInAnonymously()
            } catch {
                print("匿名ログインエラー: \(error)")
            }
        }
    }

    // MARK: - Stage Management

    /// 次のステージに進む
    func nextStage() {
        switch stage {
        case .start:
            stage = .taskInput
        case .taskInput:
            stage = .validation
        case .validation:
            stage = .missionSetup
        case .missionSetup:
            stage = .guide
        case .guide:
            stage = .finish
        case .finish:
            break // 最終ステージなので変更なし
        }
    }

    /// 初期状態にリセット
    func reset() {
        stage = .start
        steps = []
        currentStepIndex = 0
        isLoading = false
        encouragement = nil
    }

    // MARK: - Step Management

    /// 現在のステップを完了としてマークし、次のステップへ進む
    func completeStep() {
        guard currentStepIndex < steps.count else { return }

        // 現在のステップを完了としてマーク
        steps[currentStepIndex].completed = true

        // 次のステップへ進む
        currentStepIndex += 1

        // 全てのステップが完了した場合は完了画面へ
        if currentStepIndex >= steps.count {
            stage = .finish
        }
    }

    // MARK: - API Calls

    /// タスクをマイクロステップに分解
    func generateSteps(task: String) async throws {
        isLoading = true
        defer { isLoading = false }

        // ユーザーがログインしていない場合は匿名ログイン
        print("🔐 Checking user authentication...")
        if authManager.user == nil {
            print("⚠️ No user, signing in anonymously...")
            try await authManager.signInAnonymously()
        }

        // IDトークンを取得
        print("🔐 Checking ID token...")
        if authManager.idToken == nil {
            print("⚠️ No ID token, refreshing...")
            try await authManager.refreshToken()
        }

        guard let idToken = authManager.idToken else {
            print("❌ Failed to get ID token")
            throw NSError(domain: "AppViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "認証に失敗しました"])
        }

        print("✅ Using ID token: \(idToken.prefix(20))...")
        do {
            let response = try await apiClient.generateSteps(task: task, idToken: idToken)
            print("✅ Got \(response.steps.count) steps from API")
            steps = response.steps
            currentStepIndex = 0
        } catch {
            print("❌ API error: \(error)")
            throw error
        }
    }

    /// 励ましメッセージを取得
    func loadEncouragement(context: String, idToken: String) async throws {
        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await apiClient.getEncouragement(context: context, idToken: idToken)
            encouragement = response.message
        } catch {
            throw error
        }
    }
}
