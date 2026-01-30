import SwiftUI

/// ボタンのスタイルバリアント
@available(iOS 16.0, macOS 12.0, *)
enum ButtonVariant {
    case primary
    case secondary
    case outline
}

/// アプリ全体で使用する統一ボタンコンポーネント
@available(iOS 16.0, macOS 12.0, *)
struct PrimaryButton: View {
    let text: String
    let variant: ButtonVariant
    let action: () -> Void

    init(_ text: String, variant: ButtonVariant = .primary, action: @escaping () -> Void) {
        self.text = text
        self.variant = variant
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(textColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .padding(.horizontal, 24)
                .background(backgroundColor)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(borderColor, lineWidth: variant == .outline ? 2 : 0)
                )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Computed Properties

    private var backgroundColor: Color {
        switch variant {
        case .primary:
            return .indigo600
        case .secondary:
            return .emerald500
        case .outline:
            return .clear
        }
    }

    private var textColor: Color {
        switch variant {
        case .primary, .secondary:
            return .white
        case .outline:
            return .indigo600
        }
    }

    private var borderColor: Color {
        switch variant {
        case .outline:
            return .indigo600
        default:
            return .clear
        }
    }
}

// MARK: - Preview

#if DEBUG
@available(iOS 16.0, macOS 14.0, *)
#Preview {
    VStack(spacing: 16) {
        PrimaryButton("Primary Button", variant: .primary) {}
        PrimaryButton("Secondary Button", variant: .secondary) {}
        PrimaryButton("Outline Button", variant: .outline) {}
    }
    .padding()
}
#endif
