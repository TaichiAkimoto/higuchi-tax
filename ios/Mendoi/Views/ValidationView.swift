import SwiftUI

@available(iOS 16.0, macOS 12.0, *)
struct ValidationView: View {
    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // メッセージカード
            VStack(spacing: 24) {
                // アイコン
                Text("💭")
                    .font(.system(size: 72))

                // メッセージ
                VStack(spacing: 16) {
                    Text("わかります")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.slate900)

                    Text(encouragementMessage)
                        .font(.system(size: 18))
                        .foregroundColor(.slate700)
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                        .padding(.horizontal, 16)
                }

                // 装飾線
                Rectangle()
                    .fill(Color.emerald300)
                    .frame(width: 60, height: 4)
                    .cornerRadius(2)
            }
            .padding(32)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .slate300.opacity(0.3), radius: 20, x: 0, y: 10)

            Spacer()

            // 次へボタン
            PrimaryButton("次へ", variant: .primary) {
                viewModel.nextStage()
            }
            .padding(.bottom, 32)
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Computed Properties

    private var encouragementMessage: String {
        // Phase 5でAPI実装後、viewModel.encouragementを使用
        // 今は汎用メッセージを表示
        """
        やりたくないことは、誰にでもあります。
        でも大丈夫。一緒に小さく分けて、
        ひとつずつ進めていきましょう。
        """
    }
}

// MARK: - Preview

#if DEBUG
@available(iOS 16.0, macOS 14.0, *)
#Preview {
    ValidationView(viewModel: AppViewModel(authManager: AuthManager()))
}
#endif
