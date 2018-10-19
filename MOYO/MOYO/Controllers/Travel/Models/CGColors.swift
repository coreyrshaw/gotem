//
//  CGColors.swift
//  CityGuide
//
//  Copyright © 2016 dmbTeam. All rights reserved.
//

import UIKit

class CGColors: NSObject {
    
    func sleepTintColor() -> UIColor {

        return hexStringToUIColor("#2ecc71")
    }
    
    func eatTintColor() -> UIColor {
        
        return hexStringToUIColor("#3498db")
    }
    
    func enjoyTintColor() -> UIColor {
        
        return hexStringToUIColor("#9b59b6")
    }
    
    func favoritesTintColor() -> UIColor {
        
        return hexStringToUIColor("#e95ba6")
    }
    
    func greyBackgroundColor() -> UIColor {
        
        return hexStringToUIColor("#f5f5f5")
    }
    
    func borderColor() -> UIColor {
        
        return hexStringToUIColor("#e0e0e0")
    }
    
    func colorForCurrentLocationType() -> UIColor {
        
        if CGLocationsManager.sharedInstance.selectedLocationTypeIsSleep(){
            
            return CGColors().sleepTintColor()
            
        } else if CGLocationsManager.sharedInstance.selectedLocationTypeIsEat() {
            
            return CGColors().eatTintColor()
            
        } else if CGLocationsManager.sharedInstance.selectedLocationTypeIsEnjoy() {
            
            return CGColors().enjoyTintColor()
            
        } else if CGLocationsManager.sharedInstance.selectedLocationTypeIsFavorites() {
            
            return CGColors().favoritesTintColor()
        }
        else {
            return UIColor.black
        }
    }
    
    func hexStringToUIColor (_ hex:String) -> UIColor {

        var cString:String = hex.trimmingCharacters(in: .whitespaces).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 1))
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
