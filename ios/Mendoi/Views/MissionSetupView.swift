import SwiftUI

@available(iOS 16.0, macOS 12.0, *)
struct MissionSetupView: View {
    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        VStack(spacing: 32) {
            // タイトル
            VStack(spacing: 16) {
                Text("📋")
                    .font(.system(size: 64))

                Text("3つのルール")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.slate900)

                Text("これだけ守ってください")
                    .font(.system(size: 16))
                    .foregroundColor(.slate600)
            }
            .padding(.top, 48)

            // ルール一覧
            VStack(spacing: 20) {
                RuleCard(
                    number: "1",
                    title: "1ステップずつ進む",
                    description: "次のステップは考えなくてOK。今だけに集中しましょう。",
                    color: .indigo500
                )

                RuleCard(
                    number: "2",
                    title: "完璧を目指さない",
                    description: "50%の出来でも大丈夫。やらないよりずっと偉いです。",
                    color: .emerald500
                )

                RuleCard(
                    number: "3",
                    title: "途中でやめてもいい",
                    description: "疲れたら休憩。またいつでも戻ってこれます。",
                    color: .amber500
                )
            }

            Spacer()

            // スタートボタン
            PrimaryButton("スタート", variant: .primary) {
                viewModel.nextStage()
            }
            .padding(.bottom, 32)
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Rule Card Component

@available(iOS 16.0, macOS 12.0, *)
struct RuleCard: View {
    let number: String
    let title: String
    let description: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // 番号バッジ
            Text(number)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(color)
                .cornerRadius(22)

            // テキスト
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.slate900)

                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.slate600)
                    .lineSpacing(2)
            }

            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .slate300.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Preview

#if DEBUG
@available(iOS 16.0, macOS 14.0, *)
#Preview {
    MissionSetupView(viewModel: AppViewModel(authManager: AuthManager()))
}
#endif
