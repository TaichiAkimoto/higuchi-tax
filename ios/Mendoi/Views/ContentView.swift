import SwiftUI

@available(iOS 16.0, macOS 12.0, *)
struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel

    var body: some View {
        ZStack {
            // 背景グラデーション
            LinearGradient(
                colors: [.indigo50, .slate50],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // ステージごとのView
            Group {
                switch viewModel.stage {
                case .start:
                    StartView(viewModel: viewModel)
                case .taskInput:
                    TaskInputView(viewModel: viewModel)
                case .validation:
                    ValidationView(viewModel: viewModel)
                case .missionSetup:
                    MissionSetupView(viewModel: viewModel)
                case .guide:
                    GuideView(viewModel: viewModel)
                case .finish:
                    FinishView(viewModel: viewModel)
                }
            }
            .frame(maxWidth: 600) // デスクトップでの最大幅制限
            .padding(.horizontal, 16)
            .transition(.asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
            ))
            .animation(.easeInOut(duration: 0.3), value: viewModel.stage)
        }
    }
}

// MARK: - Preview

#if DEBUG
@available(iOS 16.0, macOS 14.0, *)
#Preview {
    ContentView()
        .environmentObject(AppViewModel(authManager: AuthManager()))
}
#endif
