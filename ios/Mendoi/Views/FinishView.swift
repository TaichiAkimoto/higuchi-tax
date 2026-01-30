import SwiftUI

@available(iOS 16.0, macOS 12.0, *)
struct FinishView: View {
    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // 完了メッセージ
            VStack(spacing: 24) {
                // アニメーション付き絵文字
                Text("🎉")
                    .font(.system(size: 96))
                    .scaleEffect(1.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.5), value: true)

                // メッセージ
                VStack(spacing: 16) {
                    Text("やりました！")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.slate900)

                    Text("めんどいことを\nやり遂げられました！")
                        .font(.system(size: 20))
                        .foregroundColor(.slate700)
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)

                    // 完了ステップ数
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.emerald500)
                            .font(.system(size: 20))

                        Text("\(viewModel.steps.count)ステップ完了")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.slate600)
                    }
                    .padding(.top, 8)
                }

                // 装飾線
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.emerald400, .indigo400],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 100, height: 4)
                    .cornerRadius(2)
            }
            .padding(40)
            .background(Color.white)
            .cornerRadius(24)
            .shadow(color: .slate300.opacity(0.3), radius: 20, x: 0, y: 10)

            Spacer()

            // ボタン
            VStack(spacing: 16) {
                PrimaryButton("もう一度やる", variant: .primary) {
                    withAnimation {
                        viewModel.reset()
                    }
                }

                Text("また困ったことがあったら\nいつでも戻ってきてください")
                    .font(.system(size: 14))
                    .foregroundColor(.slate500)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            .padding(.bottom, 48)
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Preview

#if DEBUG
@available(iOS 16.0, macOS 14.0, *)
#Preview {
    let viewModel = AppViewModel(authManager: AuthManager())
    viewModel.steps = [
        MicroStep(id: "step_1", label: "1. 椅子から立ち上がる", description: "完了", emoji: "🧍", completed: true),
        MicroStep(id: "step_2", label: "2. 封筒のそばに行く", description: "完了", emoji: "🚶", completed: true),
        MicroStep(id: "step_3", label: "3. 封筒を手に取る", description: "完了", emoji: "✉️", completed: true)
    ]
    viewModel.stage = .finish

    return FinishView(viewModel: viewModel)
}
#endif
