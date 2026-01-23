import SwiftUI

public struct CardSurfaceModifier: ViewModifier {
    let cornerRadius: CGFloat
    let tint: Color
    let usesGlass: Bool
    let isInteractive: Bool
    let borderColor: Color
    let shadowColor: Color
    let shadowRadius: CGFloat
    let shadowYOffset: CGFloat

    public init(
        cornerRadius: CGFloat = DSRadii.lg,
        tint: Color = Color.surface,
        usesGlass: Bool = false,
        isInteractive: Bool = false,
        borderColor: Color = Color.border,
        shadowColor: Color = DSShadows.card.color,
        shadowRadius: CGFloat = DSShadows.card.radius,
        shadowYOffset: CGFloat = DSShadows.card.y
    ) {
        self.cornerRadius = cornerRadius
        self.tint = tint
        self.usesGlass = usesGlass
        self.isInteractive = isInteractive
        self.borderColor = borderColor
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        self.shadowYOffset = shadowYOffset
    }

    public func body(content: Content) -> some View {
        let effectiveCornerRadius = min(cornerRadius, DSRadii.xl)
        let shape = RoundedRectangle(cornerRadius: effectiveCornerRadius, style: .continuous)

        if #available(iOS 26.0, *), usesGlass {
            let glass = Glass.regular.tint(tint)
            let finalGlass = isInteractive ? glass.interactive() : glass

            content
                .glassEffect(finalGlass, in: .rect(cornerRadius: effectiveCornerRadius))
                .overlay(shape.stroke(borderColor, lineWidth: 1))
                .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowYOffset)
        } else {
            content
                .background(shape.fill(tint))
                .overlay(shape.stroke(borderColor, lineWidth: 1))
                .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowYOffset)
        }
    }
}

public extension View {
    func cardSurface(
        cornerRadius: CGFloat = DSRadii.lg,
        tint: Color = Color.surface,
        usesGlass: Bool = false,
        isInteractive: Bool = false,
        borderColor: Color = Color.border,
        shadowColor: Color = DSShadows.card.color,
        shadowRadius: CGFloat = DSShadows.card.radius,
        shadowYOffset: CGFloat = DSShadows.card.y
    ) -> some View {
        modifier(
            CardSurfaceModifier(
                cornerRadius: cornerRadius,
                tint: tint,
                usesGlass: usesGlass,
                isInteractive: isInteractive,
                borderColor: borderColor,
                shadowColor: shadowColor,
                shadowRadius: shadowRadius,
                shadowYOffset: shadowYOffset
            )
        )
    }
}
