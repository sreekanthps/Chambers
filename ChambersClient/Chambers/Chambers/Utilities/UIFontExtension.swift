//
//  UIFontExtension.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 9/7/20.
//  Copyright © 2020 Swetha. All rights reserved.
//

import UIKit

extension
UIFont {
    public class func getSFProDisplayHeavyStyle(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "SFProDisplay-Heavy", size: size)
    }
    public class func getSFProDisplayMediumStyle(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "SFProDisplay-Medium", size: size)
    }
    public class func getSfProTextHeavyStyle(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "SFProText-Heavy", size: size)
    }
    public class func getSfProTextMediumStyle(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "SFProText-Medium", size: size)
    }
    public class func getSfProTextRegularStyle(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "SFProText-Regular", size: size)
    }
    public class func getSfProTextSemiBoldStyle(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "SFProText-Semibold", size: size)
    }
    public class func getSfProTextBoldStyle(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "SFProText-Bold", size: size)
    }
    public class func getDefaultFontBoldStyle(_ size: CGFloat) -> UIFont? {
        return UIFont.systemFont(ofSize: size, weight: .bold)
    }
}
