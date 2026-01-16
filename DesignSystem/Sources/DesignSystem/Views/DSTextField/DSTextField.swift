import SwiftUI

/// A styled text field following the design system.
/// Supports icons, placeholder text, and various keyboard types.
public struct DSTextField: View {
    let placeholder: String
    @Binding var text: String
    let icon: String?
    let keyboardType: UIKeyboardType
    let autocapitalization: TextInputAutocapitalization
    let isSecure: Bool

    public init(
        placeholder: String,
        text: Binding<String>,
        icon: String? = nil,
        keyboardType: UIKeyboardType = .default,
        autocapitalization: TextInputAutocapitalization = .sentences,
        isSecure: Bool = false
    ) {
        self.placeholder = placeholder
        self._text = text
        self.icon = icon
        self.keyboardType = keyboardType
        self.autocapitalization = autocapitalization
        self.isSecure = isSecure
    }

    public var body: some View {
        HStack(spacing: DSSpacing.smd) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(Color.textSecondary)
                    .frame(width: 24)
            }

            if isSecure {
                SecureField(placeholder, text: $text)
                    .textInputAutocapitalization(autocapitalization)
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(autocapitalization)
            }
        }
        .font(.system(size: 16))
        .padding(DSSpacing.md)
        .background(Color.backgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: DSSpacing.smd))
    }
}

// MARK: - Convenience Initializers

public extension DSTextField {
    /// Creates a simple text field without icon.
    static func simple(
        placeholder: String,
        text: Binding<String>
    ) -> DSTextField {
        DSTextField(
            placeholder: placeholder,
            text: text
        )
    }

    /// Creates an email text field with envelope icon.
    static func email(
        placeholder: String = "Email",
        text: Binding<String>
    ) -> DSTextField {
        DSTextField(
            placeholder: placeholder,
            text: text,
            icon: "envelope",
            keyboardType: .emailAddress,
            autocapitalization: .never
        )
    }

    /// Creates a password text field with lock icon.
    static func password(
        placeholder: String = "Password",
        text: Binding<String>
    ) -> DSTextField {
        DSTextField(
            placeholder: placeholder,
            text: text,
            icon: "lock",
            autocapitalization: .never,
            isSecure: true
        )
    }

    /// Creates a name text field with person icon.
    static func name(
        placeholder: String = "Name",
        text: Binding<String>
    ) -> DSTextField {
        DSTextField(
            placeholder: placeholder,
            text: text,
            icon: "person",
            autocapitalization: .words
        )
    }
}

// MARK: - Previews

#Preview("Basic") {
    VStack(spacing: DSSpacing.md) {
        DSTextField(
            placeholder: "Enter text",
            text: .constant("")
        )

        DSTextField(
            placeholder: "With value",
            text: .constant("Hello World")
        )
    }
    .padding()
    .background(Color.backgroundPrimary)
}

#Preview("With Icons") {
    VStack(spacing: DSSpacing.md) {
        DSTextField(
            placeholder: "Your name",
            text: .constant(""),
            icon: "person"
        )

        DSTextField(
            placeholder: "Email address",
            text: .constant(""),
            icon: "envelope",
            keyboardType: .emailAddress
        )

        DSTextField(
            placeholder: "Phone number",
            text: .constant(""),
            icon: "phone",
            keyboardType: .phonePad
        )
    }
    .padding()
    .background(Color.backgroundPrimary)
}

#Preview("Convenience Initializers") {
    VStack(spacing: DSSpacing.md) {
        DSTextField.simple(
            placeholder: "Simple field",
            text: .constant("")
        )

        DSTextField.name(
            text: .constant("")
        )

        DSTextField.email(
            text: .constant("")
        )

        DSTextField.password(
            text: .constant("")
        )
    }
    .padding()
    .background(Color.backgroundPrimary)
}

#Preview("Dark Mode") {
    VStack(spacing: DSSpacing.md) {
        DSTextField(
            placeholder: "Enter text",
            text: .constant(""),
            icon: "magnifyingglass"
        )

        DSTextField.email(
            text: .constant("user@example.com")
        )
    }
    .padding()
    .background(Color.backgroundPrimary)
    .preferredColorScheme(.dark)
}
