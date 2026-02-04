import SwiftUI

/// A standardized button component following the design system.
/// Supports multiple styles, sizes, and loading states.
public struct DSButton: View {
    let title: String
    let icon: String?
    let style: DSButtonStyle
    let size: DSButtonSize
    let isLoading: Bool
    let isEnabled: Bool
    let isFullWidth: Bool
    let action: () -> Void

    @State private var tapCount = 0

    public init(
        title: String,
        icon: String? = nil,
        style: DSButtonStyle = .primary,
        size: DSButtonSize = .medium,
        isLoading: Bool = false,
        isEnabled: Bool = true,
        isFullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.size = size
        self.isLoading = isLoading
        self.isEnabled = isEnabled
        self.isFullWidth = isFullWidth
        self.action = action
    }

    private var shouldProvideHaptics: Bool {
        style == .primary || style == .destructive
    }

    public var body: some View {
        Button(action: {
            if !isLoading && isEnabled {
                tapCount += 1
                action()
            }
        }) {
            buttonLabel
        }
        .buttonStyle(DSButtonPressStyle(style: style, cornerRadius: size.cornerRadius))
        .disabled(!isEnabled || isLoading)
        .opacity(isEnabled ? 1.0 : 0.5)
        .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.6), trigger: tapCount) { _, _ in
            shouldProvideHaptics
        }
    }

    @ViewBuilder
    private var buttonLabel: some View {
        let shape = RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous)

        let content = HStack(spacing: DSSpacing.sm) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .tint(style.foregroundColor)
                    .scaleEffect(0.8)
            } else {
                if let icon {
                    SketchIcon(systemName: icon, size: size.iconSize, color: style.foregroundColor)
                }

                Text(title)
                    .font(size.font)
            }
        }
            .foregroundStyle(style.foregroundColor)
            .padding(.horizontal, size.horizontalPadding)
            .padding(.vertical, size.verticalPadding)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .frame(minHeight: size.height)

        if style.usesGlass {
            content
                .background(
                    shape
                        .fill(style.backgroundColor)
                        .glassSurface(
                            cornerRadius: size.cornerRadius,
                            tint: style.glassTint,
                            borderColor: style.borderColor,
                            shadow: DSShadows.soft,
                            isInteractive: true
                        )
                )
        } else {
            content
                .background(shape.fill(style.backgroundStyle))
                .overlay(
                    shape.strokeBorder(style.borderColor, lineWidth: style.borderWidth)
                )
                .shadow(color: style.glowColor, radius: style.glowRadius, x: 0, y: style.glowYOffset)
        }
    }
}

// MARK: - Button Style

public enum DSButtonStyle {
    /// Filled button with primary theme color
    case primary

    /// Outlined button with primary theme color border
    case secondary

    /// Text-only button without background
    case tertiary

    /// Filled button with error color for destructive actions
    case destructive

    var backgroundColor: Color {
        switch self {
        case .primary:
            return .themePrimary
        case .secondary:
            return .surface
        case .tertiary:
            return .clear
        case .destructive:
            return .error
        }
    }

    var foregroundColor: Color {
        switch self {
        case .primary:
            return .textOnPrimary
        case .secondary:
            return .themePrimary
        case .tertiary:
            return .textSecondary
        case .destructive:
            return .textOnPrimary
        }
    }

    var borderColor: Color {
        switch self {
        case .primary:
            return .clear
        case .secondary:
            return .themePrimary.opacity(0.35)
        case .tertiary:
            return .clear
        case .destructive:
            return .clear
        }
    }

    var borderWidth: CGFloat {
        switch self {
        case .primary, .destructive:
            return 0
        case .secondary:
            return 1
        default:
            return 0
        }
    }

    var backgroundStyle: AnyShapeStyle {
        switch self {
        case .primary:
            return AnyShapeStyle(Color.themePrimary)
        case .secondary:
            return AnyShapeStyle(Color.surface)
        case .tertiary:
            return AnyShapeStyle(Color.clear)
        case .destructive:
            return AnyShapeStyle(Color.error)
        }
    }

    var glowColor: Color {
        switch self {
        case .primary:
            return Color.black.opacity(0.06)
        case .destructive:
            return Color.black.opacity(0.08)
        default:
            return Color.clear
        }
    }

    var glowRadius: CGFloat {
        switch self {
        case .primary, .destructive:
            return 4
        default:
            return 0
        }
    }

    var glowYOffset: CGFloat {
        switch self {
        case .primary, .destructive:
            return 2
        default:
            return 0
        }
    }

    var usesGlass: Bool {
        switch self {
        case .primary:
            return true
        default:
            return false
        }
    }

    var glassTint: Color {
        switch self {
        case .primary:
            return Color.themePrimary.opacity(0.3)
        case .secondary:
            return DesignSystem.tokens.glass.tint
        case .tertiary:
            return Color.textPrimary.opacity(0.02)
        case .destructive:
            return Color.error.opacity(0.25)
        default:
            return .clear
        }
    }
}

// MARK: - Button Press Style

private struct DSButtonPressStyle: ButtonStyle {
    let style: DSButtonStyle
    let cornerRadius: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        configuration.label
            .scaleEffect(pressScale(isPressed: configuration.isPressed))
            .overlay(
                shape
                    .fill(pressFill(isPressed: configuration.isPressed))
            )
            .overlay(
                shape
                    .strokeBorder(pressBorder(isPressed: configuration.isPressed), lineWidth: pressBorderWidth(isPressed: configuration.isPressed))
            )
            .animation(.spring(response: 0.22, dampingFraction: 0.72), value: configuration.isPressed)
    }

    private func pressScale(isPressed: Bool) -> CGFloat {
        guard isPressed else { return 1.0 }
        switch style {
        case .primary:
            return 1.02
        case .secondary, .destructive:
            return 0.99
        case .tertiary:
            return 0.98
        }
    }

    private func pressFill(isPressed: Bool) -> Color {
        guard isPressed else { return .clear }
        switch style {
        case .primary:
            return Color.white.opacity(0.08)
        case .secondary:
            return Color.themePrimary.opacity(0.10)
        case .tertiary:
            return Color.textPrimary.opacity(0.05)
        case .destructive:
            return Color.white.opacity(0.06)
        }
    }

    private func pressBorder(isPressed: Bool) -> Color {
        guard isPressed else { return .clear }
        switch style {
        case .secondary:
            return Color.themePrimary.opacity(0.55)
        case .tertiary:
            return Color.clear
        case .primary:
            return Color.white.opacity(0.18)
        case .destructive:
            return Color.white.opacity(0.12)
        }
    }

    private func pressBorderWidth(isPressed: Bool) -> CGFloat {
        guard isPressed else { return 0 }
        switch style {
        case .secondary:
            return 1.0
        case .primary, .destructive:
            return 0.5
        case .tertiary:
            return 0
        }
    }
}

// MARK: - Button Size

public enum DSButtonSize {
    case small
    case medium
    case large

    var fontSize: CGFloat {
        switch self {
        case .small: return 13
        case .medium: return 15
        case .large: return 17
        }
    }

    var iconSize: CGFloat {
        switch self {
        case .small: return 12
        case .medium: return 14
        case .large: return 16
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .small: return DSSpacing.smd
        case .medium: return DSSpacing.md
        case .large: return DSSpacing.lg
        }
    }

    var verticalPadding: CGFloat {
        switch self {
        case .small: return DSSpacing.sm
        case .medium: return DSSpacing.smd
        case .large: return DSSpacing.md
        }
    }

    var cornerRadius: CGFloat {
        switch self {
        case .small: return DSRadii.sm
        case .medium: return DSRadii.lg
        case .large: return DSRadii.xl
        }
    }

    var font: Font {
        switch self {
        case .small:
            return .buttonSmall()
        case .medium:
            return .buttonMedium()
        case .large:
            return .buttonLarge()
        }
    }

    var height: CGFloat {
        switch self {
        case .small:
            return 40
        case .medium:
            return 48
        case .large:
            return 56
        }
    }
}

// MARK: - Convenience Initializers

public extension DSButton {
    /// Creates a primary full-width CTA button.
    static func cta(
        title: String,
        icon: String? = nil,
        isLoading: Bool = false,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) -> DSButton {
        DSButton(
            title: title,
            icon: icon,
            style: .primary,
            size: .medium,
            isLoading: isLoading,
            isEnabled: isEnabled,
            isFullWidth: true,
            action: action
        )
    }

    /// Creates a destructive action button.
    static func destructive(
        title: String,
        icon: String? = "trash",
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) -> DSButton {
        DSButton(
            title: title,
            icon: icon,
            style: .destructive,
            size: .medium,
            isLoading: isLoading,
            action: action
        )
    }

    /// Creates a text-only link-style button.
    static func link(
        title: String,
        action: @escaping () -> Void
    ) -> DSButton {
        DSButton(
            title: title,
            style: .tertiary,
            size: .medium,
            action: action
        )
    }
}

// MARK: - Icon-Only Button

/// A button that displays only an icon without text.
public struct DSIconButton: View {
    let icon: String
    let style: DSButtonStyle
    let size: DSIconButtonSize
    let usesGlass: Bool
    let showsBackground: Bool
    let glassTint: Color?
    let accessibilityLabel: String?
    let action: (() -> Void)?

    public init(
        icon: String,
        style: DSButtonStyle = .tertiary,
        size: DSIconButtonSize = .medium,
        usesGlass: Bool = false,
        showsBackground: Bool = true,
        glassTint: Color? = DesignSystem.tokens.glass.tint,
        accessibilityLabel: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.style = style
        self.size = size
        self.usesGlass = usesGlass
        self.showsBackground = showsBackground
        self.glassTint = glassTint
        self.accessibilityLabel = accessibilityLabel
        self.action = action
    }

    public var body: some View {
        let content = iconContent

        if let action {
            Button(action: action) {
                content
            }
            .buttonStyle(.plain)
            .accessibilityLabel(Text(accessibilityLabel ?? icon))
        } else {
            content
                .accessibilityHidden(true)
        }
    }

    private var iconTint: Color {
        switch style {
        case .destructive:
            return .error
        case .tertiary:
            return .textSecondary
        default:
            return .themePrimary
        }
    }

    private var iconBackground: Color {
        switch style {
        case .destructive:
            return Color.error.opacity(0.12)
        case .tertiary:
            return Color.surfaceVariant.opacity(0.6)
        default:
            return Color.surfaceVariant.opacity(0.8)
        }
    }

    @ViewBuilder
    private var iconContent: some View {
        if showsBackground {
            IconTileSurface(
                size: size.dimension,
                cornerRadius: DSRadii.lg,
                fill: iconBackground,
                borderColor: style == .tertiary ? .clear : Color.border,
                borderWidth: style == .tertiary ? 0 : 1,
                shadow: DSShadows.soft,
                glassTint: glassTint,
                usesGlass: usesGlass,
                isInteractive: action != nil
            ) {
                SketchIcon(systemName: icon, size: size.iconSize, color: iconTint)
            }
        } else {
            SketchIcon(systemName: icon, size: size.iconSize, color: iconTint)
                .frame(width: size.dimension, height: size.dimension)
                .contentShape(.rect)
        }
    }
}

public enum DSIconButtonSize {
    case small
    case medium
    case large

    var iconSize: CGFloat {
        switch self {
        case .small: return 16
        case .medium: return 18
        case .large: return 22
        }
    }

    var dimension: CGFloat {
        switch self {
        case .small: return 44
        case .medium: return 48
        case .large: return 56
        }
    }
}

// MARK: - Previews

#Preview("Primary Buttons") {
    VStack(spacing: DSSpacing.md) {
        DSButton(title: "Small Primary", size: .small) {}
        DSButton(title: "Medium Primary", size: .medium) {}
        DSButton(title: "Large Primary", size: .large) {}
        DSButton(title: "With Icon", icon: "arrow.right", size: .medium) {}
        DSButton(title: "Full Width", isFullWidth: true) {}
    }
    .padding()
    .background(Color.backgroundPrimary)
}

#Preview("Secondary Buttons") {
    VStack(spacing: DSSpacing.md) {
        DSButton(title: "Small Secondary", style: .secondary, size: .small) {}
        DSButton(title: "Medium Secondary", style: .secondary) {}
        DSButton(title: "Large Secondary", style: .secondary, size: .large) {}
        DSButton(title: "With Icon", icon: "plus", style: .secondary) {}
    }
    .padding()
    .background(Color.backgroundPrimary)
}

#Preview("Tertiary & Destructive") {
    VStack(spacing: DSSpacing.md) {
        DSButton(title: "Tertiary Button", style: .tertiary) {}
        DSButton(title: "Destructive Button", style: .destructive) {}
        DSButton.destructive(title: "Delete", action: {})
        DSButton.link(title: "Learn More", action: {})
    }
    .padding()
    .background(Color.backgroundPrimary)
}

#Preview("States") {
    VStack(spacing: DSSpacing.md) {
        DSButton(title: "Normal") {}
        DSButton(title: "Loading", isLoading: true) {}
        DSButton(title: "Disabled", isEnabled: false) {}
    }
    .padding()
    .background(Color.backgroundPrimary)
}

#Preview("CTA Button") {
    VStack(spacing: DSSpacing.md) {
        DSButton.cta(title: "Continue") {}
        DSButton.cta(title: "Loading...", isLoading: true) {}
        DSButton.cta(title: "Disabled", isEnabled: false) {}
    }
    .padding()
    .background(Color.backgroundPrimary)
}

#Preview("Icon Buttons") {
    HStack(spacing: DSSpacing.md) {
        DSIconButton(icon: "heart.fill", style: .primary, size: .small) {}
        DSIconButton(icon: "heart.fill", style: .primary, size: .medium) {}
        DSIconButton(icon: "heart.fill", style: .primary, size: .large) {}
        DSIconButton(icon: "plus", style: .secondary) {}
        DSIconButton(icon: "xmark", style: .tertiary) {}
    }
    .padding()
    .background(Color.backgroundPrimary)
}

#Preview("Dark Mode") {
    VStack(spacing: DSSpacing.md) {
        DSButton(title: "Primary") {}
        DSButton(title: "Secondary", style: .secondary) {}
        DSButton(title: "Destructive", style: .destructive) {}
        DSButton.cta(title: "Get Started") {}
    }
    .padding()
    .background(Color.backgroundPrimary)
    .preferredColorScheme(.dark)
}
