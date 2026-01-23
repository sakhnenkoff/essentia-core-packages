import SwiftUI

/// Default theme tuned for a calm, minimal, sketch-like aesthetic
public struct DefaultTheme: Theme, Sendable {
    public let tokens: DesignTokens

    public init() {
        let colors = ColorPalette(
            primary: .adaptivePrimary,
            secondary: .adaptiveSecondary,
            accent: .adaptiveAccent,
            success: .adaptiveSuccess,
            warning: .adaptiveWarning,
            error: .adaptiveError,
            info: .adaptiveInfo,
            backgroundPrimary: .adaptiveBackgroundPrimary,
            backgroundSecondary: .adaptiveBackgroundSecondary,
            backgroundTertiary: .adaptiveTertiaryBackground,
            textPrimary: .adaptiveTextPrimary,
            textSecondary: .adaptiveTextSecondary,
            textTertiary: .adaptiveTextTertiary,
            textOnPrimary: Color(light: .white, dark: .textPrimaryLight),
            surface: .adaptiveSurface,
            surfaceVariant: .adaptiveSurfaceVariant,
            border: .adaptiveBorder,
            divider: .adaptiveDivider
        )

        let typography = TypographyScale(
            titleLarge: TextStyle(size: 26, weight: .semibold, design: .monospaced),
            titleMedium: TextStyle(size: 22, weight: .semibold, design: .monospaced),
            titleSmall: TextStyle(size: 18, weight: .semibold, design: .monospaced),
            headlineLarge: TextStyle(size: 17, weight: .semibold, design: .monospaced),
            headlineMedium: TextStyle(size: 15, weight: .semibold, design: .monospaced),
            headlineSmall: TextStyle(size: 13, weight: .semibold, design: .monospaced),
            bodyLarge: TextStyle(size: 15, weight: .regular, design: .monospaced),
            bodyMedium: TextStyle(size: 13, weight: .regular, design: .monospaced),
            bodySmall: TextStyle(size: 12, weight: .regular, design: .monospaced),
            captionLarge: TextStyle(size: 11, weight: .regular, design: .monospaced),
            captionSmall: TextStyle(size: 10, weight: .regular, design: .monospaced),
            buttonLarge: TextStyle(size: 14, weight: .semibold, design: .monospaced),
            buttonMedium: TextStyle(size: 13, weight: .semibold, design: .monospaced),
            buttonSmall: TextStyle(size: 12, weight: .semibold, design: .monospaced)
        )

        let spacing = SpacingScale(
            xs: 4,
            sm: 8,
            smd: 12,
            md: 16,
            mlg: 20,
            lg: 24,
            xl: 32,
            xxlg: 40,
            xxl: 52
        )

        let radii = RadiiScale(
            xs: 8,
            sm: 12,
            md: 18,
            lg: 24,
            xl: 32,
            pill: 999
        )

        let shadows = ShadowScale(
            soft: ShadowToken(color: .black.opacity(0.06), radius: 8, y: 4),
            card: ShadowToken(color: .black.opacity(0.12), radius: 16, y: 8),
            lifted: ShadowToken(color: .black.opacity(0.16), radius: 22, y: 12)
        )

        let glass = GlassTokens(
            tint: Color.white.opacity(0.12),
            strongTint: Color.white.opacity(0.22),
            border: Color.white.opacity(0.5),
            shadow: ShadowToken(color: .black.opacity(0.12), radius: 12, y: 6)
        )

        self.tokens = DesignTokens(
            colors: colors,
            typography: typography,
            spacing: spacing,
            radii: radii,
            shadows: shadows,
            glass: glass
        )
    }
}
