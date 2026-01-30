import SwiftUI
import FirebaseCore

@main
@available(iOS 16.0, macOS 12.0, *)
struct MendoiApp: App {
    @StateObject private var authManager = AuthManager()
    @StateObject private var viewModel: AppViewModel

    init() {
        // Firebase初期化
        FirebaseApp.configure()

        // AuthManagerとAppViewModelを初期化
        let authMgr = AuthManager()
        _authManager = StateObject(wrappedValue: authMgr)
        _viewModel = StateObject(wrappedValue: AppViewModel(authManager: authMgr))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
