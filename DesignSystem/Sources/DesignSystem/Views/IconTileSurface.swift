import SwiftUI

public struct IconTileSurface<Content: View>: View {
    let size: CGFloat
    let cornerRadius: CGFloat
    let fill: Color
    let borderColor: Color
    let borderWidth: CGFloat
    let shadow: ShadowToken
    let glassTint: Color?
    let usesGlass: Bool
    let isInteractive: Bool
    let content: Content

    public init(
        size: CGFloat = 32,
        cornerRadius: CGFloat = DSRadii.md,
        fill: Color = Color.surfaceVariant.opacity(0.8),
        borderColor: Color = Color.border,
        borderWidth: CGFloat = 1,
        shadow: ShadowToken = DSShadows.soft,
        glassTint: Color? = DesignSystem.tokens.glass.tint,
        usesGlass: Bool = false,
        isInteractive: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.size = size
        self.cornerRadius = cornerRadius
        self.fill = fill
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.shadow = shadow
        self.glassTint = glassTint
        self.usesGlass = usesGlass
        self.isInteractive = isInteractive
        self.content = content()
    }

    public var body: some View {
        let tile = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        let base = content
            .frame(width: size, height: size)
            .background(tile.fill(fill))

        if usesGlass {
            let resolvedTint = glassTint ?? .clear
            base.glassSurface(
                cornerRadius: cornerRadius,
                tint: resolvedTint,
                borderColor: borderColor,
                shadow: shadow,
                isInteractive: isInteractive
            )
        } else {
            base
                .overlay(tile.stroke(borderColor.opacity(borderWidth == 0 ? 0 : 0.6), lineWidth: borderWidth))
                .shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
        }
    }
}

#Preview("Icon Tile Surface") {
    HStack(spacing: DSSpacing.md) {
        IconTileSurface(size: 32, borderColor: .clear, borderWidth: 0, shadow: ShadowToken(color: .clear, radius: 0)) {
            SketchIcon(systemName: "sparkles", size: 16, color: .themePrimary)
        }

        IconTileSurface(size: 48, usesGlass: true, isInteractive: true) {
            SketchIcon(systemName: "heart", size: 18, color: .themePrimary)
        }
    }
    .padding()
    .background(Color.backgroundPrimary)
}
