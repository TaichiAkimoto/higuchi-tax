import SwiftUI

/// プログレスバーコンポーネント
@available(iOS 16.0, macOS 12.0, *)
struct ProgressBar: View {
    let current: Int
    let total: Int

    private var progress: Double {
        guard total > 0 else { return 0 }
        return Double(current) / Double(total)
    }

    private var percentage: Int {
        Int(progress * 100)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // パーセンテージ表示
            Text("\(percentage)%")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.slate600)

            // プログレスバー
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // 背景
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.slate200)
                        .frame(height: 8)

                    // 進行状況
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.emerald500)
                        .frame(width: geometry.size.width * progress, height: 8)
                        .animation(.easeInOut(duration: 0.3), value: progress)
                }
            }
            .frame(height: 8)

            // ステップ数表示
            Text("\(current) / \(total) ステップ完了")
                .font(.system(size: 12))
                .foregroundColor(.slate500)
        }
    }
}

// MARK: - Preview

#if DEBUG
@available(iOS 16.0, macOS 14.0, *)
#Preview {
    VStack(spacing: 32) {
        ProgressBar(current: 0, total: 6)
        ProgressBar(current: 3, total: 6)
        ProgressBar(current: 6, total: 6)
    }
    .padding()
}
#endif
