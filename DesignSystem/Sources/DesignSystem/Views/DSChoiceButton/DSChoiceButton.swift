import SwiftUI

/// A selectable choice button for onboarding flows, surveys, and multi-select interfaces.
/// Displays a title, optional subtitle, optional icon, and selection state.
public struct DSChoiceButton: View {
    let title: String
    let subtitle: String?
    let icon: String?
    let isSelected: Bool
    let action: () -> Void

    public init(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        isSelected: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.isSelected = isSelected
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: DSSpacing.smd) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(isSelected ? Color.themePrimary : Color.textSecondary)
                        .frame(width: 24)
                }

                VStack(alignment: .leading, spacing: DSSpacing.xs) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.textPrimary)

                    if let subtitle {
                        Text(subtitle)
                            .font(.system(size: 13))
                            .foregroundStyle(Color.textSecondary)
                    }
                }

                Spacer(minLength: DSSpacing.sm)

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22))
                    .foregroundStyle(isSelected ? Color.themePrimary : Color.textTertiary)
            }
            .padding(DSSpacing.md)
            .background(isSelected ? Color.themePrimary.opacity(0.08) : Color.backgroundSecondary)
            .overlay(
                RoundedRectangle(cornerRadius: DSSpacing.smd)
                    .stroke(isSelected ? Color.themePrimary : Color.clear, lineWidth: 2)
            )
            .clipShape(RoundedRectangle(cornerRadius: DSSpacing.smd))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Convenience Initializers

public extension DSChoiceButton {
    /// Creates a simple choice button with just a title.
    static func simple(
        title: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> DSChoiceButton {
        DSChoiceButton(
            title: title,
            isSelected: isSelected,
            action: action
        )
    }

    /// Creates an icon choice button with icon and title.
    static func withIcon(
        title: String,
        icon: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> DSChoiceButton {
        DSChoiceButton(
            title: title,
            icon: icon,
            isSelected: isSelected,
            action: action
        )
    }
}

// MARK: - Previews

#Preview("Unselected") {
    VStack(spacing: DSSpacing.sm) {
        DSChoiceButton(
            title: "Option One",
            isSelected: false
        ) {}

        DSChoiceButton(
            title: "With Subtitle",
            subtitle: "This is a description",
            isSelected: false
        ) {}

        DSChoiceButton(
            title: "With Icon",
            icon: "star.fill",
            isSelected: false
        ) {}

        DSChoiceButton(
            title: "Full Option",
            subtitle: "Icon and subtitle",
            icon: "heart.fill",
            isSelected: false
        ) {}
    }
    .padding()
    .background(Color.backgroundPrimary)
}

#Preview("Selected") {
    VStack(spacing: DSSpacing.sm) {
        DSChoiceButton(
            title: "Option One",
            isSelected: true
        ) {}

        DSChoiceButton(
            title: "With Subtitle",
            subtitle: "This is a description",
            isSelected: true
        ) {}

        DSChoiceButton(
            title: "With Icon",
            icon: "star.fill",
            isSelected: true
        ) {}

        DSChoiceButton(
            title: "Full Option",
            subtitle: "Icon and subtitle",
            icon: "heart.fill",
            isSelected: true
        ) {}
    }
    .padding()
    .background(Color.backgroundPrimary)
}

#Preview("Mixed Selection") {
    VStack(spacing: DSSpacing.sm) {
        DSChoiceButton(
            title: "Launch fast",
            icon: "paperplane.fill",
            isSelected: true
        ) {}

        DSChoiceButton(
            title: "Monetize",
            icon: "creditcard.fill",
            isSelected: false
        ) {}

        DSChoiceButton(
            title: "Measure growth",
            icon: "chart.line.uptrend.xyaxis",
            isSelected: true
        ) {}
    }
    .padding()
    .background(Color.backgroundPrimary)
}

#Preview("Dark Mode") {
    VStack(spacing: DSSpacing.sm) {
        DSChoiceButton(
            title: "Selected Option",
            icon: "star.fill",
            isSelected: true
        ) {}

        DSChoiceButton(
            title: "Unselected Option",
            icon: "heart.fill",
            isSelected: false
        ) {}
    }
    .padding()
    .background(Color.backgroundPrimary)
    .preferredColorScheme(.dark)
}
