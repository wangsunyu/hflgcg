//
//  AppTheme.swift
//  HFITCampus
//
//  Created on 2026-03-31.
//

import SwiftUI

enum AppTheme {

    // MARK: - Colors

    static let primaryColor = Color(hex: 0x0070E3)
    static let secondaryColor = Color(hex: 0x34C759)
    static let backgroundColor = Color(.systemGroupedBackground)
    static let cardBackgroundColor = Color(.secondarySystemGroupedBackground)
    static let textPrimaryColor = Color(.label)
    static let textSecondaryColor = Color(.secondaryLabel)
    static let separatorColor = Color(.separator)

    // MARK: - Spacing

    static let paddingSmall: CGFloat = 8
    static let paddingMedium: CGFloat = 16
    static let paddingLarge: CGFloat = 24
    static let paddingXLarge: CGFloat = 32

    // MARK: - Corner Radius

    static let cornerRadiusSmall: CGFloat = 8
    static let cornerRadiusMedium: CGFloat = 12
    static let cornerRadiusLarge: CGFloat = 16

    // MARK: - Font Sizes

    static let fontSizeSmall: CGFloat = 12
    static let fontSizeMedium: CGFloat = 14
    static let fontSizeLarge: CGFloat = 16
    static let fontSizeXLarge: CGFloat = 18
    static let fontSizeTitle: CGFloat = 20
}

// MARK: - Color Extension

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex >> 16) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
