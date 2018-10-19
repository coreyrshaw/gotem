//
//  Constants.swift
//
//  Created by Corey S on 31/07/18.
//  Copyright © 2018 Moyo. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

var app_delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

//http://164.132.170.155/apidetail/

class GlobalVariables{
    
    // These are the properties you can store in your singleton
    
    
    //DeveciToken DeviceId
    public var strDeviceToken :String?      = String()
    public var strFBDeviceToken :String?         = String()
    public var strDeviceID :String?         = String()
    public var location_to_Edit :String?         = String()
    public var cateGory_dictionary = NSDictionary()
    public var user_Role = String()
    public var user_Image = String()
    
    public var user_Office_add = String()
    public var user_add = String()
    public var user_Gender = String()
    public var user_Mobile = String()
    //  user login dictionary
    public var user_Login_dictionary : NSMutableDictionary!
    public var userPayment_dictionary : NSMutableDictionary!
    public var show_array_LatLong :  NSArray = NSArray()
    
    var currentLocation : CLLocation!
    public var currentLat:Double = 0.0
    public var currentLong:Double = 0.0
    
    
    //Flag
    public var isMyProfileUpdate: Bool      = false
    public var isLogin: Bool                = false
    
    public var petInfoAdd: Bool             = false
    
    //CURRENT USER DETAILS
    public var Actype    :String             = ""
    public var user_id    :String             = ""
    public var Email    :String             = ""
    public var Password    :String             = ""
    public var Actypes    :String             = ""
    public var Actypess   :String             = ""
    public var Actypesa    :String             = ""
    public var Username    :String             = ""
    //    public var Actype    :String             = ""
    //    public var Actype    :String             = ""
    //    public var Actype    :String             = ""
    //    public var Actype    :String             = ""
    
    
    
    class var sharedManager: GlobalVariables {
        struct Static {
            static let instance = GlobalVariables()
            // create viewController code...
            
        }
        
        return Static.instance
    }
    
    
    
    
    //For Side Menu
    var arrMenuImageAndTitle: NSMutableArray = NSMutableArray()
    
    //For Home Dashboard
    var dictHomeDashboard: NSMutableDictionary = NSMutableDictionary()
    
    
    
    
    
    //MARK: - SideMenu
}
