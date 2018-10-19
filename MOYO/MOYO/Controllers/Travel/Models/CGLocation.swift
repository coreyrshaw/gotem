//
//  CGLocation.swift
//  CityGuide
//
//  Copyright © 2016 dmbTeam. All rights reserved.
//

import UIKit

class CGLocation: NSObject {

    var locationData:Data!
    
    var locationAddress : String = ""
    var locationName    : String = ""
    var locationID      : String = ""
    
    var locationPhotoReference = [String]()
    var locationTypes          = [String]()
    
    var locationPriceRating : Double!
    var locationLongitude   : Double!
    var locationLatitude    : Double!
    var locationRating      : Double!
    
    var locationTypeIsEnjoy : Bool = false
    var locationTypeIsSleep : Bool = false
    var locationTypeIsEat   : Bool = false
    
    init(JSON: NSDictionary) {
        super.init()
        
        if let locName = JSON["name"] as? String {
            self.locationName = locName
        }
        
        if let locAddress = JSON["vicinity"] as? String {
            self.locationAddress = locAddress
        }
        
        if let locID = JSON["place_id"] as? String {
            self.locationID = locID
        }
        
        if let photos = JSON["photos"] as? [NSDictionary] {
            for photo in photos {
                if let photoRef = photo["photo_reference"] as? String {
                    let locationPhotoRefence = photoRef
                    self.locationPhotoReference.append(locationPhotoRefence)
                }
            }
        }
        
        if let locPriceRating = JSON["price_level"] as? Double {
             self.locationPriceRating = locPriceRating
        }
        
        if let locRating = JSON["rating"] as? Double {
            self.locationRating = locRating
        }
        
        if let types = JSON["types"] as? NSArray {
            for type in types {
                self.locationTypes.append(type as! String)
            }
        }
        
        if let locGeometry = JSON["geometry"] as? NSDictionary  {
            if let locationCoords = locGeometry["location"] as? NSDictionary {
                
                if let locLat = locationCoords["lat"] as? Double {
                    self.locationLatitude = locLat
                }
                
                if let locLong = locationCoords["lng"] as? Double {
                    self.locationLongitude = locLong
                }
            }
        }
        
        self.locationData = NSKeyedArchiver.archivedData(withRootObject: JSON)
        
        if self.locationTypes.contains(Constants.searchTextSleep) {
            
            self.locationTypeIsSleep = true
            
        } else {
            
            let restaurantKeys = Constants.searchTextEat.components(separatedBy: "|")
            for key in restaurantKeys {
                if self.locationTypes.contains(key) {
                    self.locationTypeIsEat = true
                    return
                }
            }
            
            let enjoyKeys = Constants.searchTextEat.components(separatedBy: "|")
            for key in enjoyKeys {
                if self.locationTypes.contains(key) {
                    self.locationTypeIsEnjoy = true
                    return
                }
            }
        }
    }
}
