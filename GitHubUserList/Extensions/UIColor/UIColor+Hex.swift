//
//  UIColor+Hex.swift
//  GitHubUserList
//
//  Created by Tim Chen on 2025/5/14.
//

import UIKit

extension UIColor {
    convenience init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        // 去除前綴 #
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }

        let length = hexString.count
        var alpha: CGFloat = 1.0
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0

        var hexValue: UInt64 = 0
        guard Scanner(string: hexString).scanHexInt64(&hexValue) else {
            self.init(red: 0, green: 0, blue: 0, alpha: 1.0)
            return
        }

        switch length {
        case 3: // RGB (12-bit)
            red   = CGFloat((hexValue & 0xF00) >> 8) / 15.0
            green = CGFloat((hexValue & 0x0F0) >> 4) / 15.0
            blue  = CGFloat(hexValue & 0x00F) / 15.0
        case 4: // RGBA (16-bit)
            red   = CGFloat((hexValue & 0xF000) >> 12) / 15.0
            green = CGFloat((hexValue & 0x0F00) >> 8) / 15.0
            blue  = CGFloat((hexValue & 0x00F0) >> 4) / 15.0
            alpha = CGFloat(hexValue & 0x000F) / 15.0
        case 6: // RRGGBB (24-bit)
            red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
            green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
            blue  = CGFloat(hexValue & 0x0000FF) / 255.0
        case 8: // RRGGBBAA (32-bit)
            red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
            green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
            blue  = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
            alpha = CGFloat(hexValue & 0x000000FF) / 255.0
        default:
            self.init(red: 0, green: 0, blue: 0, alpha: 1.0)
            return 
        }

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
