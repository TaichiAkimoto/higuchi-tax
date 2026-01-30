import SwiftUI

@available(iOS 16.0, macOS 12.0, *)
struct StartView: View {
    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // タイトル
            VStack(spacing: 16) {
                Text("😮‍💨")
                    .font(.system(size: 80))

                Text("めんどい")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.slate900)

                Text("やりたくないことを、\nちょっとだけ助けます")
                    .font(.system(size: 18))
                    .foregroundColor(.slate600)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }

            Spacer()

            // スタートボタン
            VStack(spacing: 16) {
                PrimaryButton("助けてもらう", variant: .primary) {
                    viewModel.nextStage()
                }

                Text("面倒なことを小さなステップに分けて\n一歩ずつサポートします")
                    .font(.system(size: 14))
                    .foregroundColor(.slate500)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }

            Spacer()
        }
        .padding(.vertical, 48)
    }
}

// MARK: - Preview

#if DEBUG
@available(iOS 16.0, macOS 14.0, *)
#Preview {
    StartView(viewModel: AppViewModel(authManager: AuthManager()))
}
#endif
