//
//  UIColorExtension.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 9/7/20.
//  Copyright © 2020 Swetha. All rights reserved.
//

import UIKit

extension UIColor {
    
     class func hexColor(_ hex: String, alpha: CGFloat = 1.0) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines as CharacterSet).uppercased()

        if cString.hasPrefix("#") {
            cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 1))
        }

        if cString.count != 6 {
            return UIColor.red
        }

        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

