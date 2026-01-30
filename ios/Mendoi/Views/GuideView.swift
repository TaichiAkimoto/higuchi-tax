import SwiftUI

@available(iOS 16.0, macOS 12.0, *)
struct GuideView: View {
    @ObservedObject var viewModel: AppViewModel

    private var currentStep: MicroStep? {
        guard viewModel.currentStepIndex < viewModel.steps.count else { return nil }
        return viewModel.steps[viewModel.currentStepIndex]
    }

    var body: some View {
        VStack(spacing: 32) {
            // プログレスバー
            ProgressBar(
                current: viewModel.currentStepIndex,
                total: viewModel.steps.count
            )
            .padding(.top, 32)

            Spacer()

            // 現在のステップ表示
            if let step = currentStep {
                VStack(spacing: 24) {
                    // 絵文字
                    Text(step.emoji)
                        .font(.system(size: 96))

                    // ステップラベル
                    Text(step.label)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.slate900)
                        .multilineTextAlignment(.center)

                    // ステップ説明
                    Text(step.description)
                        .font(.system(size: 16))
                        .foregroundColor(.slate600)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 24)

                    // 装飾線
                    Rectangle()
                        .fill(Color.indigo300)
                        .frame(width: 60, height: 4)
                        .cornerRadius(2)
                }
                .padding(32)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .slate300.opacity(0.3), radius: 20, x: 0, y: 10)
            } else {
                // ステップがない場合（フォールバック）
                VStack(spacing: 16) {
                    Text("🎯")
                        .font(.system(size: 64))

                    Text("ステップの準備中...")
                        .font(.system(size: 18))
                        .foregroundColor(.slate600)
                }
            }

            Spacer()

            // 完了ボタン
            VStack(spacing: 12) {
                PrimaryButton("やった！", variant: .primary) {
                    withAnimation {
                        viewModel.completeStep()
                    }
                }

                // 進捗テキスト
                if viewModel.steps.count > 0 {
                    Text("残り \(viewModel.steps.count - viewModel.currentStepIndex) ステップ")
                        .font(.system(size: 14))
                        .foregroundColor(.slate500)
                }
            }
            .padding(.bottom, 32)
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
        MicroStep(id: "step_1", label: "1. 椅子から立ち上がる", description: "まずは物理的に体を動かしてみよう", emoji: "🧍", completed: false),
        MicroStep(id: "step_2", label: "2. 封筒のそばに行く", description: "封筒がある場所まで移動する", emoji: "🚶", completed: false),
        MicroStep(id: "step_3", label: "3. 封筒を手に取る", description: "まだ開けなくていい、持つだけ", emoji: "✉️", completed: false)
    ]
    viewModel.stage = .guide

    return GuideView(viewModel: viewModel)
}
#endif
