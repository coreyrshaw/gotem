//
//  CGDailyForecast.swift
//  CityGuide
//
//  Copyright © 2016 dmbTeam. All rights reserved.
//

import UIKit

class CGDailyForecast: NSObject {
    
    var forecastCondition   : String = ""
    var feracastDate        : String = ""
    var forecastText        : String = ""
    
    var forecastIcon        : UIImage!
    
    init(JSON: NSDictionary) {
        super.init()

        if let interval = JSON["dt"] as? Double {
            let timeInterval = interval
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE, dd MMM yyyy"
            dateFormatter.timeZone =  NSTimeZone.local
            let dateString = dateFormatter.string(from: Date(timeIntervalSince1970:timeInterval))
            self.feracastDate = dateString
        }
        
        if let temp = JSON["temp"] as? NSDictionary {
            if let dayForecast  = temp["day"] as? Int  {
                self.forecastCondition = String(format: "%d° C", dayForecast)
            }
        }
        
        if let weather = JSON["weather"] as? NSArray {
            if let weatherFirstObject = weather[0] as? NSDictionary {
                if let weatherMainForecast = weatherFirstObject["main"] as? String {
                    self.forecastText = weatherMainForecast
                }
                
                if let weatherIcon = weatherFirstObject["icon"] as? String {
                    self.forecastIcon = UIImage(named:String(format: "forecast_%@", weatherIcon))
                }
            }
        }
    }
}
