import SwiftUI

/// A custom boolean toggle with two side-by-side pills.
///
/// On state (left pill) displays a filled icon, off state (right pill) displays a dot indicator.
/// Both pills are contained in a single rounded container with a subtle border.
public struct DSPillToggle: View {
    @Binding var isOn: Bool
    let icon: String
    let usesGlass: Bool
    let accessibilityLabel: String?
    @Namespace private var namespace

    public init(
        isOn: Binding<Bool>,
        icon: String = "leaf",
        usesGlass: Bool = true,
        accessibilityLabel: String? = nil
    ) {
        self._isOn = isOn
        self.icon = icon
        self.usesGlass = usesGlass
        self.accessibilityLabel = accessibilityLabel
    }

    public var body: some View {
        let pillSize: CGFloat = 52
        let iconSize: CGFloat = 20
        let dotSize: CGFloat = 8
        let padding = DSSpacing.xs
        let shape = RoundedRectangle(cornerRadius: DSRadii.lg, style: .continuous)
        let selectionShape = RoundedRectangle(cornerRadius: DSRadii.sm, style: .continuous)

        let content = HStack(spacing: 0) {
            // On pill (icon)
            Button {
                guard !isOn else { return }
                withAnimation(.spring(duration: 0.35, bounce: 0.2)) { isOn = true }
            } label: {
                ZStack {
                    if isOn {
                        selectionShape
                            .fill(Color.themePrimary)
                            .matchedGeometryEffect(id: "selection", in: namespace)
                    }

                    Image(systemName: icon)
                        .font(.system(size: iconSize, weight: .medium))
                        .foregroundStyle(isOn ? Color.textOnPrimary : Color.textTertiary)
                }
                .frame(width: pillSize, height: pillSize)
            }
            .buttonStyle(.plain)
            .accessibilityHidden(true)

            // Off pill (dot)
            Button {
                guard isOn else { return }
                withAnimation(.spring(duration: 0.35, bounce: 0.2)) { isOn = false }
            } label: {
                ZStack {
                    if !isOn {
                        selectionShape
                            .fill(Color.surfaceVariant.opacity(0.9))
                            .matchedGeometryEffect(id: "selection", in: namespace)
                    }

                    Circle()
                        .fill(isOn ? Color.textTertiary : Color.themePrimary)
                        .frame(width: dotSize, height: dotSize)
                }
                .frame(width: pillSize, height: pillSize)
            }
            .buttonStyle(.plain)
            .accessibilityHidden(true)
        }
        .padding(padding)
        .background(shape.fill(usesGlass ? Color.clear : Color.surface))

        let styled = Group {
            if usesGlass {
                content.glassSurface(
                    cornerRadius: DSRadii.lg,
                    tint: DesignSystem.tokens.glass.tint,
                    borderColor: Color.border,
                    shadow: DSShadows.soft,
                    isInteractive: true
                )
                .clipShape(shape)
            } else {
                content.overlay(
                    shape.stroke(Color.border, lineWidth: 1)
                )
            }
        }

        return styled
            .sensoryFeedback(.selection, trigger: isOn)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(resolvedAccessibilityLabel)
            .accessibilityValue(isOn ? "On" : "Off")
            .accessibilityAddTraits(.isButton)
            .accessibilityAction { isOn.toggle() }
    }

    private var resolvedAccessibilityLabel: String {
        if let accessibilityLabel {
            return accessibilityLabel
        }

        var label = icon
        if label.hasSuffix(".fill") {
            label = String(label.dropLast(5))
        }
        label = label.replacingOccurrences(of: ".", with: " ")
        return label.capitalized
    }
}

#Preview("DSPillToggle") {
    struct PreviewWrapper: View {
        @State private var isOn = true

        var body: some View {
            VStack(spacing: DSSpacing.md) {
                DSPillToggle(isOn: $isOn, icon: "leaf.fill", accessibilityLabel: "Environment mode")
                DSPillToggle(isOn: .constant(false), icon: "bell.fill")
                DSPillToggle(isOn: .constant(true), icon: "heart.fill")
            }
            .padding()
            .background(Color.backgroundPrimary)
        }
    }

    return PreviewWrapper()
}
