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
                guard !isOn else { return }
                withAnimation(.spring(duration: 0.3, bounce: 0.15)) { isOn = true }
            } label: {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(isOn ? Color.textOnPrimary : Color.textTertiary)
                    .frame(width: 52, height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: DSRadii.sm)
                            .fill(isOn ? Color.themePrimary : Color.clear)
                    )
            }
            .buttonStyle(.plain)

            // Off pill (dot)
            Button {
                guard isOn else { return }
                withAnimation(.spring(duration: 0.3, bounce: 0.15)) { isOn = false }
            } label: {
                Circle()
                    .fill(!isOn ? Color.themePrimary : Color.textTertiary)
                    .frame(width: 8, height: 8)
                    .frame(width: 52, height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: DSRadii.sm)
                            .fill(!isOn ? Color.surfaceVariant : Color.clear)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(5)
        .background(Color.surface)
        .clipShape(RoundedRectangle(cornerRadius: DSRadii.lg))
        .overlay(
            RoundedRectangle(cornerRadius: DSRadii.lg)
                .stroke(Color.border, lineWidth: 1)
        )
        .animation(.spring(duration: 0.3, bounce: 0.15), value: isOn)
        .sensoryFeedback(.selection, trigger: isOn)
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
