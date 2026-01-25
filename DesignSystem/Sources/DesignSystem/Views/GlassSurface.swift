import SwiftUI

public struct GlassSurfaceModifier: ViewModifier {
    let cornerRadius: CGFloat
    let tint: Color
    let borderColor: Color
    let shadow: ShadowToken
    let isInteractive: Bool

    public init(
        cornerRadius: CGFloat = DSRadii.lg,
        tint: Color = DesignSystem.tokens.glass.tint,
        borderColor: Color = DesignSystem.tokens.glass.border,
        shadow: ShadowToken = DesignSystem.tokens.glass.shadow,
        isInteractive: Bool = false
    ) {
        self.cornerRadius = cornerRadius
        self.tint = tint
        self.borderColor = borderColor
        self.shadow = shadow
        self.isInteractive = isInteractive
    }

    public func body(content: Content) -> some View {
        let effectiveCornerRadius = min(cornerRadius, DSRadii.xl)
        let shape = RoundedRectangle(cornerRadius: effectiveCornerRadius, style: .continuous)
        let hasBorder = borderColor != .clear

        if #available(iOS 26.0, *) {
            let glass = Glass.regular.tint(tint)
            let finalGlass = isInteractive ? glass.interactive() : glass

            // Liquid Glass handles its own edges - don't add extra overlays
            content
                .glassEffect(finalGlass, in: .rect(cornerRadius: effectiveCornerRadius))
        } else {
            // Fallback for pre-iOS 26: use material + border + shadow
            content
                .background(.ultraThinMaterial, in: shape)
                .overlay {
                    if hasBorder {
                        shape.stroke(borderColor, lineWidth: 1)
                    }
                }
                .shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
        }
    }
}

public extension View {
    func glassSurface(
        cornerRadius: CGFloat = DSRadii.lg,
        tint: Color = DesignSystem.tokens.glass.tint,
        borderColor: Color = DesignSystem.tokens.glass.border,
        shadow: ShadowToken = DesignSystem.tokens.glass.shadow,
        isInteractive: Bool = false
    ) -> some View {
        modifier(
            GlassSurfaceModifier(
                cornerRadius: cornerRadius,
                tint: tint,
                borderColor: borderColor,
                shadow: shadow,
                isInteractive: isInteractive
            )
        )
    }
}
