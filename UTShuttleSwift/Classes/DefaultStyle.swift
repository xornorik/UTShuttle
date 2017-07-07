//
//  DefaultStyle.swift
//  SuperShuttle
//
//  Created by Vemuri, Srinivas on 7/7/17.
//
//

import Foundation
import UIKit
//import ZAlertView

public class DefaultStyle: NSObject {
    
    static var sharedInstance = DefaultStyle()
    
    func apply() {
        
        UIWindow.appearance().tintColor = ColorPalette.UTSTeal
        
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = ColorPalette.UTSTeal
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName : UIFont(name: "Helvetica Neue", size: 15)!]
        //UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont(name: "Roboto-Light", size: 14)!], forState: UIControlState.Normal)
        
        UITextField.appearance().textColor = UIColor.black
        
    }
}

public struct ColorPalette {
    
    
    static let UTSTeal = UIColor(hex: "#5DC5BB")

    
}

extension UIColor {
    
    public convenience init(hex: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if hex.hasPrefix("#") {
            
            let currentIndex = hex.startIndex
            let index   = hex.index(currentIndex, offsetBy: 1) //.startIndex.advancedBy(1)
            let hex     = hex.substring(from: index) //.substringFromIndex(index)
            let scanner = Scanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            
            if scanner.scanHexInt64(&hexValue) {
                switch (hex.characters.count) {
                case 3:
                    red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                    blue  = CGFloat(hexValue & 0x00F)              / 15.0
                case 4:
                    red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                    blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                    alpha = CGFloat(hexValue & 0x000F)             / 15.0
                case 6:
                    red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
                case 8:
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                default:
                    break
                }
            }
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    
    func darkerColorForColor(color: UIColor) -> UIColor {
        
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        
        if color.getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: max(r - 0.2, 0.0), green: max(g - 0.2, 0.0), blue: max(b - 0.2, 0.0), alpha: a)
        }
        
        return UIColor()
    }
    
    func lighterColorForColor(color: UIColor) -> UIColor {
        
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        
        if color.getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: min(r + 0.2, 1.0), green: min(g + 0.2, 1.0), blue: min(b + 0.2, 1.0), alpha: a)
        }
        
        return UIColor()
    }
    
}

