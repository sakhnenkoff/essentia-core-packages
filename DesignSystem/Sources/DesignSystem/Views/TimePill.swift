import SwiftUI

/// A pill that displays a time value.
///
/// Supports two modes:
/// - Static: Display-only with a title string
/// - Interactive: Tappable with time picker sheet
public struct TimePill: View {
    private enum Mode {
        case staticTitle(String)
        case interactive(Binding<Date>)
    }

    private let mode: Mode
    let isHighlighted: Bool
    let usesGlass: Bool
    @State private var isShowingPicker = false

    /// Creates a static time pill for display only.
    public init(
        title: String,
        isHighlighted: Bool = true,
        usesGlass: Bool = false
    ) {
        self.mode = .staticTitle(title)
        self.isHighlighted = isHighlighted
        self.usesGlass = usesGlass
    }

    /// Creates an interactive time pill with time picker.
    public init(
        time: Binding<Date>,
        isHighlighted: Bool = true,
        usesGlass: Bool = false
    ) {
        self.mode = .interactive(time)
        self.isHighlighted = isHighlighted
        self.usesGlass = usesGlass
    }

    private var displayTitle: String {
        switch mode {
        case .staticTitle(let title):
            return title
        case .interactive(let binding):
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: binding.wrappedValue)
        }
    }

    public var body: some View {
        switch mode {
        case .staticTitle:
            pillContent
        case .interactive(let binding):
            Button {
                isShowingPicker = true
            } label: {
                pillContent
            }
            .buttonStyle(.plain)
            .contentShape(Capsule())
            .sheet(isPresented: $isShowingPicker) {
                timePickerSheet(binding: binding)
            }
        }
    }

    private var pillContent: some View {
        let textContent = Text(displayTitle)
            .font(.bodyMedium())
            .foregroundStyle(isHighlighted ? Color.themePrimary : Color.textSecondary)
            .padding(.horizontal, DSSpacing.md)
            .padding(.vertical, DSSpacing.smd)

        return Group {
            if usesGlass {
                textContent
                    .background(Capsule().fill(Color.clear))
                    .glassSurface(
                        cornerRadius: DSRadii.pill,
                        tint: isHighlighted ? Color.themePrimary.opacity(0.15) : DesignSystem.tokens.glass.tint,
                        borderColor: .clear,
                        shadow: DSShadows.soft,
                        isInteractive: true
                    )
            } else {
                textContent
                    .background(Capsule().fill(isHighlighted ? Color.surface : Color.surfaceVariant))
                    .overlay(
                        Capsule().stroke(Color.themePrimary.opacity(0.2), lineWidth: 1)
                    )
            }
        }
    }

    private func timePickerSheet(binding: Binding<Date>) -> some View {
        NavigationStack {
            VStack(spacing: DSSpacing.xl) {
                DatePicker(
                    "",
                    selection: binding,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .labelsHidden()

                DSButton(title: "Done", style: .primary) {
                    isShowingPicker = false
                }
            }
            .padding(DSSpacing.xl)
            .navigationTitle("Select Time")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        isShowingPicker = false
                    }
                    .font(.bodyMedium())
                    .foregroundStyle(Color.themePrimary)
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

#Preview("Static TimePill") {
    VStack(spacing: DSSpacing.md) {
        TimePill(title: "17:00")
        TimePill(title: "08:30", isHighlighted: false)
        TimePill(title: "11:15", usesGlass: true)
    }
    .padding()
    .background(Color.backgroundPrimary)
}

#Preview("Interactive TimePill") {
    struct PreviewWrapper: View {
        @State private var time = Date()

        var body: some View {
            VStack(spacing: DSSpacing.md) {
                TimePill(time: $time)
                TimePill(time: $time, usesGlass: true)

                Text("Selected: \(time.formatted(date: .omitted, time: .shortened))")
                    .font(.bodySmall())
                    .foregroundStyle(Color.textSecondary)
            }
            .padding()
            .background(Color.backgroundPrimary)
        }
    }

    return PreviewWrapper()
}
