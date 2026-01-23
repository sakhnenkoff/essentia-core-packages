#if canImport(UIKit)
import UIKit
import SwiftUI

public enum DesignSystemAppearance {
    public static func apply(using tokens: DesignTokens) {
        let textColor = UIColor(tokens.colors.textPrimary)
        let mutedTextColor = UIColor(tokens.colors.textTertiary)
        let accentColor = UIColor(tokens.colors.primary)
        let dividerColor = UIColor(tokens.colors.divider)

        let titleFont = UIFont.monospacedSystemFont(
            ofSize: tokens.typography.headlineLarge.size,
            weight: .semibold
        )
        let largeTitleFont = UIFont.monospacedSystemFont(
            ofSize: tokens.typography.titleLarge.size,
            weight: .semibold
        )

        // Use default background to properly adapt to dark/light mode
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithDefaultBackground()
        navAppearance.titleTextAttributes = [
            .font: titleFont,
            .foregroundColor: textColor
        ]
        navAppearance.largeTitleTextAttributes = [
            .font: largeTitleFont,
            .foregroundColor: textColor
        ]
        navAppearance.shadowColor = .clear

        let navBar = UINavigationBar.appearance()
        navBar.standardAppearance = navAppearance
        navBar.scrollEdgeAppearance = navAppearance
        navBar.compactAppearance = navAppearance
        navBar.tintColor = accentColor

        // Use default background to properly adapt to dark/light mode
        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithDefaultBackground()
        tabAppearance.shadowColor = dividerColor

        let normalFont = UIFont.monospacedSystemFont(
            ofSize: tokens.typography.bodySmall.size,
            weight: .regular
        )
        let selectedFont = UIFont.monospacedSystemFont(
            ofSize: tokens.typography.bodySmall.size,
            weight: .semibold
        )

        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: normalFont,
            .foregroundColor: mutedTextColor
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: selectedFont,
            .foregroundColor: accentColor
        ]

        tabAppearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
        tabAppearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
        tabAppearance.stackedLayoutAppearance.normal.iconColor = mutedTextColor
        tabAppearance.stackedLayoutAppearance.selected.iconColor = accentColor

        tabAppearance.inlineLayoutAppearance.normal.titleTextAttributes = normalAttributes
        tabAppearance.inlineLayoutAppearance.selected.titleTextAttributes = selectedAttributes
        tabAppearance.inlineLayoutAppearance.normal.iconColor = mutedTextColor
        tabAppearance.inlineLayoutAppearance.selected.iconColor = accentColor

        tabAppearance.compactInlineLayoutAppearance.normal.titleTextAttributes = normalAttributes
        tabAppearance.compactInlineLayoutAppearance.selected.titleTextAttributes = selectedAttributes
        tabAppearance.compactInlineLayoutAppearance.normal.iconColor = mutedTextColor
        tabAppearance.compactInlineLayoutAppearance.selected.iconColor = accentColor

        let tabBar = UITabBar.appearance()
        tabBar.standardAppearance = tabAppearance
        tabBar.scrollEdgeAppearance = tabAppearance
        tabBar.tintColor = accentColor
    }
}
#endif
