import SwiftUI

public struct GlassSegmentedControl: View {
    let items: [String]
    @Binding var selection: String

    public init(items: [String], selection: Binding<String>) {
        self.items = items
        self._selection = selection
    }

    public var body: some View {
        Picker("", selection: $selection) {
            ForEach(items, id: \.self) { item in
                Text(item)
                    .tag(item)
            }
        }
        .pickerStyle(.segmented)
        .tint(Color.themePrimary)
        .font(.captionLarge())
    }
}

#Preview("Glass Segmented") {
    GlassSegmentedControl(items: ["Daily", "Weekly", "Monthly"], selection: .constant("Daily"))
        .padding()
        .background(Color.backgroundPrimary)
}
