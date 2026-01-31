import SwiftUI
import Lottie

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 24) {
            // Lottieアニメーション
            LottieView(animation: .named("loading-animation"))
                .playing(loopMode: .loop)
                .frame(width: 200, height: 200)

            // ローディングテキスト
            Text("AI が考え中...")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.slate600)

            Text("マイクロステップを作成しています")
                .font(.system(size: 14))
                .foregroundColor(.slate500)
        }
    }
}

#if DEBUG
@available(iOS 16.0, macOS 14.0, *)
#Preview {
    LoadingView()
}
#endif
