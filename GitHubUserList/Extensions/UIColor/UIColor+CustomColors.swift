//
//  UIColor+CustomColors.swift
//  GitHubUserList
//
//  Created by Tim Chen on 2025/5/14.
//

import UIKit

extension UIColor {
    //MARK: 文字顏色
    static var labelColor: UIColor {
        return UIColor.dynamic(light: UIColor(hex: "#000000"), dark:  UIColor(hex: "#FFFFFF"))
    }
    //MARK: 背景顏色
    static var backgroundColor: UIColor {
        return UIColor.dynamic(light: UIColor(hex: "#FFFFFF"), dark:  UIColor(hex: "#000000"))
    }
}
