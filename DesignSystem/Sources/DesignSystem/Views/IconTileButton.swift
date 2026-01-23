import SwiftUI

public struct IconTileButton: View {
    let systemName: String
    let size: CGFloat
    let iconSize: CGFloat
    let tint: Color
    let backgroundTint: Color
    let usesGlass: Bool
    let action: (() -> Void)?

    public init(
        systemName: String,
        size: CGFloat = 48,
        iconSize: CGFloat = 18,
        tint: Color = Color.themePrimary,
        backgroundTint: Color = Color.surfaceVariant.opacity(0.8),
        usesGlass: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.systemName = systemName
        self.size = size
        self.iconSize = iconSize
        self.tint = tint
        self.backgroundTint = backgroundTint
        self.usesGlass = usesGlass
        self.action = action
    }

    public var body: some View {
        let content = IconTileSurface(
            size: size,
            cornerRadius: DSRadii.lg,
            fill: backgroundTint,
            borderColor: Color.border,
            shadow: DSShadows.soft,
            usesGlass: usesGlass,
            isInteractive: action != nil
        ) {
            SketchIcon(systemName: systemName, size: iconSize, color: tint)
        }

        if let action {
            Button(action: action) {
                content
            }
            .buttonStyle(.plain)
        } else {
            content
        }
    }
}

#Preview("Icon Tile") {
    HStack(spacing: DSSpacing.md) {
        IconTileButton(systemName: "heart")
        IconTileButton(systemName: "tray.and.arrow.down")
    }
    .padding()
    .background(Color.backgroundPrimary)
}
