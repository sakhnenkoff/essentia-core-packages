import SwiftUI

/// A custom boolean toggle with two side-by-side pills.
///
/// On state (left pill) displays a filled icon, off state (right pill) displays a dot indicator.
/// Both pills are contained in a single rounded container with a subtle border.
public struct DSPillToggle: View {
    @Binding var isOn: Bool
    let icon: String
    let usesGlass: Bool

    public init(
        isOn: Binding<Bool>,
        icon: String = "leaf",
        usesGlass: Bool = true
    ) {
        self._isOn = isOn
        self.icon = icon
        self.usesGlass = usesGlass
    }

    public var body: some View {
        HStack(spacing: 0) {
            // On pill (icon)
            Button {
                withAnimation(.easeInOut(duration: 0.2)) { isOn = true }
            } label: {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(isOn ? Color.textOnPrimary : Color.textTertiary)
                    .frame(width: 44, height: 44)
                    .background(isOn ? Color.themePrimary : Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: DSRadii.sm))
            }
            .buttonStyle(.plain)

            // Off pill (dot)
            Button {
                withAnimation(.easeInOut(duration: 0.2)) { isOn = false }
            } label: {
                Circle()
                    .fill(!isOn ? Color.themePrimary : Color.textTertiary)
                    .frame(width: 6, height: 6)
                    .frame(width: 44, height: 44)
                    .background(!isOn ? Color.surfaceVariant : Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: DSRadii.sm))
            }
            .buttonStyle(.plain)
        }
        .padding(4)
        .background(Color.surface)
        .clipShape(RoundedRectangle(cornerRadius: DSRadii.md))
        .overlay(
            RoundedRectangle(cornerRadius: DSRadii.md)
                .stroke(Color.border, lineWidth: 1)
        )
    }
}

#Preview("DSPillToggle") {
    struct PreviewWrapper: View {
        @State private var isOn = true

        var body: some View {
            VStack(spacing: DSSpacing.md) {
                DSPillToggle(isOn: $isOn, icon: "leaf.fill")
                DSPillToggle(isOn: .constant(false), icon: "bell.fill")
                DSPillToggle(isOn: .constant(true), icon: "heart.fill")
            }
            .padding()
            .background(Color.backgroundPrimary)
        }
    }

    return PreviewWrapper()
}
