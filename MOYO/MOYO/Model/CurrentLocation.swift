//
//  CurrentLocation.swift
//  MOYO
//
//  Created by Corey.S on 7/30/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import Foundation


class CurrentLocation {
    
    init() {
        print("Location Object Created")
    }
    deinit {
        print("Location Object Destroyed")
    }
    
    private var _latitude: Double?
    private var _longitude: Double?
    private var _title: String?
    
    var latitude : Double{
        set{
            _latitude = newValue
        }
        get{
            if _latitude == nil{
                _latitude = 0
            }
            return _latitude!
        }
    }
    
    var longitude : Double{
        set{
            _longitude = newValue
        }
        get{
            if _longitude == nil{
                _longitude = 0
            }
            return _longitude!
        }
    }
    
    var title : String{
        set{
            _title = newValue
        }
        get{
            if _title == nil{
                _title = emptyString
            }
            return _title!
        }
    }
    
}
