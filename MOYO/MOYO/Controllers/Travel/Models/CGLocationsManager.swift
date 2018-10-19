//
//  CGLocationsManager.swift
//  CityGuide
//
//  Copyright © 2016 dmbTeam. All rights reserved.
//

import UIKit

class CGLocationsManager: NSObject {
    
    static let sharedInstance = CGLocationsManager()
    
    var selectedLocationsType = ""
    
    func selectedLocationTypeIsSleep() -> Bool {
        return selectedLocationsType == Constants.locationTypeSleep ? true : false
    }
    
    func selectedLocationTypeIsEat() -> Bool {
        return selectedLocationsType == Constants.locationTypeEat ? true : false
    }
    
    func selectedLocationTypeIsEnjoy() -> Bool {
        return selectedLocationsType == Constants.locationTypeEnjoy ? true : false
    }
    
    func selectedLocationTypeIsFavorites() -> Bool {
        return selectedLocationsType == Constants.locationTypeFavorites ? true : false
    }
}
