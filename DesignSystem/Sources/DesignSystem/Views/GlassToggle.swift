import SwiftUI

public struct GlassToggle: View {
    @Binding var isOn: Bool
    let onTint: Color

    public init(
        isOn: Binding<Bool>,
        onTint: Color = Color.themePrimary
    ) {
        self._isOn = isOn
        self.onTint = onTint
    }

    public var body: some View {
        Toggle("", isOn: $isOn)
            .labelsHidden()
            .toggleStyle(.switch)
            .tint(onTint)
            .accessibilityValue(isOn ? "On" : "Off")
    }
}

#Preview("Glass Toggle") {
    VStack(spacing: DSSpacing.md) {
        GlassToggle(isOn: .constant(true))
        GlassToggle(isOn: .constant(false))
    }
    .padding()
    .background(Color.backgroundPrimary)
}
