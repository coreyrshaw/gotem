//
//  CGLocationReview.swift
//  CityGuide
//
//  Copyright © 2016 dmbTeam. All rights reserved.
//

import UIKit

class CGLocationReview: NSObject {

    var aurotImageURL   : String = ""
    var reviewText      : String = ""
    var reviewDate      : String = ""
    var autorName       : String = ""
    
    var locationRating:Double = 0.0
    
    init(JSON: NSDictionary) {
        super.init()
        
        if let name = JSON["author_name"] as? String {
            self.autorName = name
        }
        
        if let locRating = JSON["rating"] as? Double {
            self.locationRating = locRating
        }
        
        if let text = JSON["text"] as? String {
            self.reviewText = text
        }
        
        if let interval = JSON["time"] as? Double {
            let timeInterval = interval
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            dateFormatter.timeZone = TimeZone.current
            let dateString = dateFormatter.string(from: Date(timeIntervalSince1970:timeInterval))
            self.reviewDate = dateString
        }
        
        if let photoURL = JSON["profile_photo_url"] as? String {
            self.aurotImageURL = String(format: "https:%@", photoURL)
        }
    }
}
