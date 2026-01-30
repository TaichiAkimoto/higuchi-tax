import Foundation
import FirebaseAuth

/// Firebase匿名認証を管理するクラス
@available(iOS 16.0, macOS 10.15, *)
@MainActor
class AuthManager: ObservableObject {
    @Published var user: User?
    @Published var idToken: String?

    init() {
        // 初期化時に現在のユーザーをチェック
        self.user = Auth.auth().currentUser
    }

    /// 匿名ログインを実行
    func signInAnonymously() async throws {
        print("🔐 Starting anonymous sign in...")
        let result = try await Auth.auth().signInAnonymously()
        self.user = result.user
        print("✅ Anonymous sign in successful, UID: \(result.user.uid)")
        try await refreshToken()
        print("✅ ID token refreshed")
    }

    /// IDトークンを更新
    func refreshToken() async throws {
        guard let currentUser = Auth.auth().currentUser else {
            throw NSError(domain: "AuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])
        }
        self.idToken = try await currentUser.getIDToken()
    }

    /// ログアウト
    func signOut() throws {
        try Auth.auth().signOut()
        self.user = nil
        self.idToken = nil
    }
}
