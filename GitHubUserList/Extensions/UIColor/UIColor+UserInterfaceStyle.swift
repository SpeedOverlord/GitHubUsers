//
//  UIColor+UserInterfaceStyle.swift
//  GitHubUserList
//
//  Created by Tim Chen on 2025/5/14.
//

import UIKit

extension UIColor {
    static func dynamic(light: UIColor, dark: UIColor) -> UIColor {
        return UIColor { trait in
            return trait.userInterfaceStyle == .dark ? dark : light
        }
    }
}
