//
//  color-extension.swift
//  annoyed-alarm
//
//  Created by Nazwa Sapta Pradana on 19/03/26.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b: UInt64
        switch hex.count {
        case 6:
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (255, 255, 255)
        }

        let uiColor = UIColor(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: 1
        )

        self.init(uiColor)
    }
}

extension Color {

    // MARK: - Primary
    static let primary500 = Color(hex: "#FF3B30")
    static let primary600 = Color(hex: "#E0352B")
    static let primary700 = Color(hex: "#C22F26")
    
    // MARK: - Secondary
    static let secondary500 = Color(hex: "#FF6A00")
    static let secondary600 = Color(hex: "#E55F00")
    
    // MARK: - Accent
    static let accent500 = Color(hex: "#FF6A00")
    static let accent600 = Color(hex: "#E55F00")
    
    // MARK: - Background
    static let backgroundDefault = Color(hex: "#0F0F10")
    static let backgroundSecondary = Color(hex: "#1C1C1E")
    static let backgroundTertiary = Color(hex: "#2C2C2E")
    
    // MARK: - Text
    static let textPrimary = Color(hex: "#FFFFFF")
    static let textSecondary = Color(hex: "#8E8E93")
    static let textDisabled = Color(hex: "#636366")
    
    // MARK: - Feedback
    static let success = Color(hex: "#30D158")
    static let error = Color(hex: "#FF453A")
    static let warning = Color(hex: "#FFD60A")
    static let info = Color(hex: "#0A84FF")
    
    // MARK: - Border
    static let borderDefault = Color(hex: "#3A3A3C")
    static let borderSubtle = Color(hex: "#48484A")
    
    // MARK: - Surface
    static let surface500 = Color(hex: "#2C2C2E")
}

extension Color {
    
    static var invertedBackground: Color {
        Color(uiColor: UIColor { trait in
            trait.userInterfaceStyle == .dark ? .white : .black
        })
    }

    static var invertedText: Color {
        Color(uiColor: UIColor { trait in
            trait.userInterfaceStyle == .dark ? .black : .white
        })
    }
}
