//
//  Constants.swift
//  CityGuide
//
//  Copyright © 2016 dmbTeam. All rights reserved.
//

import UIKit
import GooglePlaces

class Constants: NSObject {
    
    // Location of the city you want - we recommend to use the city center's coordinates
    static let cityLatitude             = "33.787996848"
    static let cityLongitude            = "-84.320665384"
    
    
    // GOOGLE PLACES
    // 1. Google Places Key
    static let placesApiKey             = GoogleKey
    
    // 2. The radius used for the requests - we recommend to keep it as it is
    static let locationsSearchRadius    = "10000"
    
    // 3. Google Places categories that are included in Sleep, Eat and Enjoy
    static let searchTextSleep          = "lodging"
    static let searchTextEat            = "bakery|meal_delivery|meal_takeaway|food|restaurant"
    static let searchTextEnjoy          = "gym|park|stadium"
    
    // OTHERS
    // 1. OpenWeather API Key
    static let weatherApiKey            = "05eb8857a16de5b29e75bd39dc86c6dd"
    
    // 2. AppStore's App ID - used for opening AppStore in order to rate the app
    static let appId                    = "397336487"
    
    // 3. AdMob ID - Used for ads / set true to enable and false to disable. This is Test ID only for testing
    static let addId                    = "PUT_YOUR_ADMOB_BANNER_KEY_HERE"
    static let enableAds:Bool           = false

    // 4. Help constants - DO NOT MODIFY!
    static let locationTypeSleep        = "sleep"
    static let locationTypeEat          = "eat"
    static let locationTypeEnjoy        = "gym,park,boxing,track,football,basketball"
    static let locationTypeFavorites    = "favorites"
    
    
    
}
