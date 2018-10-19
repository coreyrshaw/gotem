//
//  AppDelegate.swift
//  MOYO
//
//  Created by Christopher Myers on 6/19/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import UserNotifications
import CoreData

let weatherAPIKey = "e7b7bb506f476f34425d7cb6a3903887"
let pollutionAPIKey = "27624D17-ABBB-4FFE-BF82-C84B27D6A621"//"73637498-BE6A-46B0-9322-A1F1F987FB80"
let vitalNote =  "Please upload your vital sign values for today."
let foodNote = "Please upload your food diary values for today."

let actionUpload = "Upload"
let actionLater = "Upload later"

let notificationIDVital = "com.moyo.vital.notification"
let notificationIDFood = "com.moyo.food.notification"

let actionIDVitalCategory = "UPLOAD_VITAL"
let actionIDVitalLater = "LATER_UPLOAD_VITAL"
let actionIDVitalUpload = "UPLOAD_VITAL"

let actionIDFoodCategory = "UPLOAD_FOOD"
let actionIDFoodLater = "LATER_UPLOAD_FOOD"
let actionIDFoodUpload = "UPLOAD_FOOD"

let notificationPeriod: TimeInterval = 24 * 60 * 60
let laterNotificationPeriod: TimeInterval = 60 * 60

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    static var appDelegate: AppDelegate? = nil
    
    internal var locationManager = CLLocationManager()
    internal let getDataQueue = DispatchQueue(label: "com.moyo.fetch", qos: .userInteractive, attributes: [.concurrent])
    internal let sendDataQueue = DispatchQueue(label: "com.moyo.send", qos: .userInteractive, attributes: [.concurrent])
    internal var isWorking = false
    internal var shouldSendData = false
        internal var reqSent = false
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        AppDelegate.appDelegate = self
        GMSServices.provideAPIKey(GoogleKey)
        GMSPlacesClient.provideAPIKey(GoogleKey)
        
        locationManager.delegate = self
        enableLocationServices()
        // to be sure
        if DataHolder.userID == nil {
            DataHolder.token = nil
        }
        if let location = launchOptions?.first(where: { $0.key == UIApplicationLaunchOptionsKey.location})?.value as? Bool, location {
            startBgTask(application: application)
        }
        else {
            if let _ = DataHolder.token {
                self.window?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainNav")
            }
            else  {
                self.window?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginController")
            }
        }
        DispatchQueue.main.async {
            self.sendCurrentData()
        }
        UINavigationBar.appearance().barStyle = .blackOpaque
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.black
        ]
        UINavigationBar.appearance().tintColor = UIColor.black
        
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)//(60*60)
        registerLocalNotifications()
        checkNotificationStatus()
        return true
    }
    var bgTask: UIBackgroundTaskIdentifier? = nil
    var fetchCompletion:((UIBackgroundFetchResult) -> Void)? = nil
    //internal var bgTask: Backg
    func startBgTask(application: UIApplication) {
        bgTask = application.beginBackgroundTask(withName: "getData", expirationHandler: {
            if let task = self.bgTask {
                application.endBackgroundTask(task)
            }
            self.bgTask = nil
        })
        self.sendCurrentData()
    }
    func sendCurrentData(loc: CLLocation? = nil) {
        if isWorking {
            return
        }
        var location = loc
        if location == nil {
            guard let loc2 = locationManager.location else {
                self.shouldSendData = true
                self.locationManager.requestLocation()
                return
            }
            location = loc2
        }
        var weather: CurrentWeather? = nil
        var pollution: CurrentPollution? = nil
        getDataQueue.async {
            self.isWorking = true
            let asyncGroup = DispatchGroup()
            let weatherService = WeatherService(APIKey: weatherAPIKey)
            asyncGroup.enter()
            weatherService.getCurrentWeather(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!) { (currentWeather) in
                weather =  currentWeather
                asyncGroup.leave()
            }
//            let pollutionService = PollutionService(APIKey: pollutionAPIKey)
//            asyncGroup.enter()
//            pollutionService.getCurrentPollution(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, completion: { (currentPolution) in
//                pollution = currentPolution
//                asyncGroup.leave()
//            })
            asyncGroup.notify(queue: self.sendDataQueue) {
                let asyncGroupSend = DispatchGroup()
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                let (formattedDate, millis) = formattedDateAndMillis()
                // send weather
                asyncGroupSend.enter()
                if let user = DataHolder.userID, let wt = weather?.temperature, let wh = weather?.humidity, let wp = weather?.precipProbability, let ws = weather?.summary {
                    let fileName = "\(formattedDate)/\(millis)/\(user)+weather.csv"
                    // send data
                    let string = "participant_id,time,temperature,humidity,precipProbabibility,summary,categoryName\n" +
                                 "\(user),\(millis),\(wt),\(wh),\(wp),\(ws)"
                    let data = string.data(using: .utf8)!
                    let nf = documentsPath + "/" + fileName.replacingOccurrences(of: "/", with: "-")
                    try? data.write(to: URL(fileURLWithPath: nf, isDirectory: false))
                    print("data weather:\n" + String(data: data, encoding:.utf8)!)
                    API.default.uploadFile(millis: millis, data: data, fileName:fileName, completion: { (result) in
                        print("result data sending: \(result)")
                        asyncGroupSend.leave()
                    })
                }
                else {
                    asyncGroupSend.leave()
                }
                /*
                // send pollution
                asyncGroupSend.enter()
                if let user = DataHolder.userID, let pn = pollution?.Category.Number, let pname = pollution?.Category.Name {

                    let formmatter = DateFormatter()
                    formmatter.dateFormat = "yyyyMMdd-hh:mm"
                    let fileName = "\(formattedDate)/\(millis)/\(user)+pollution.csv"
                    // send data
                    let string = "participant_id,categoryNumber,categoryName\n" +
                    "\(user),\(pn),\(pname)"
                    let data = string.data(using: .utf8)!
                    let nf = documentsPath + "/" + fileName.replacingOccurrences(of: "/", with: "-")
                    try? data.write(to: URL(fileURLWithPath: nf, isDirectory: false))
                    print("data pollution:\n" + String(data: data, encoding:.utf8)!)
                    API.default.uploadFile(millis: millis, data: data, fileName:fileName, completion: { (result) in
                        print("result data sending: \(result)")
                        asyncGroupSend.leave()
                    })
                }
                else {
                    asyncGroupSend.leave()
                }
                */
                asyncGroup.notify(queue: DispatchQueue.main){
                    self.isWorking = false
                    self.endBackgroundTask()
                }
            }
        }
    }
    func endBackgroundTask() {
        if let task = self.bgTask {
           UIApplication.shared.endBackgroundTask(task)
            self.bgTask = nil
        }
        fetchCompletion?(.newData)
    }
    func enableBackground() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startMonitoringSignificantLocationChanges()
    }
    func enableLocationServices() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            if CLLocationManager.authorizationStatus() == .authorizedAlways {
                enableBackground()
            }
        case .restricted, .denied:
            print("Failed")
        case .authorizedWhenInUse:
            enableBackground()
        case .authorizedAlways:
            enableBackground()
        }
    }
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        self.fetchCompletion = completionHandler
        sendCurrentData()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            sendCurrentData(loc: locations.first)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location error:\(error)")
    }
    func logout() {
        DataHolder.token = nil
        DataHolder.userID = nil
        self.window?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginController")
    }
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "dmbTeam.CityGuide" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "Travel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("Travel.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}
extension AppDelegate {
    func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                    // Schedule Local Notification
                    self.scheduleNotificationsIfNeeded()
                })
            case .denied:
                print("Application Not Allowed to Display Notifications")
            default:
                self.scheduleNotificationsIfNeeded()
                
            }
        }
    }
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            completionHandler(success)
        }
    }
    func registerLocalNotifications() {
        UNUserNotificationCenter.current().delegate = self
        // upload later vital
        let laterUploadVital = UNNotificationAction(identifier: actionIDVitalLater, title: actionLater, options: [])
        // upload vital
        let uploadVital = UNNotificationAction(identifier: actionIDVitalUpload,
                                               title: actionUpload, options: [.authenticationRequired,.foreground])
        // food
        let laterUploadFood = UNNotificationAction(identifier: actionIDFoodLater, title: actionLater, options: [])
        // upload vital
        let uploadFood = UNNotificationAction(identifier: actionIDFoodUpload,
                                              title: actionUpload, options: [.authenticationRequired,.foreground])
        
        
        // category vital
        let vitalCategory = UNNotificationCategory(identifier: actionIDVitalCategory, actions: [uploadVital, laterUploadVital], intentIdentifiers: [uploadVital.identifier, laterUploadVital.identifier], options: [])
        
        // category food
        let foodCategory = UNNotificationCategory(identifier: actionIDFoodCategory, actions: [uploadFood, laterUploadFood], intentIdentifiers: [uploadFood.identifier, laterUploadFood.identifier], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([vitalCategory, foodCategory])
        scheduleNotificationsIfNeeded()
    }
    func scheduleNotificationsIfNeeded() {
        if DataHolder.token != nil {
            if !reqSent {
                reqSent = true
                UNUserNotificationCenter.current().getPendingNotificationRequests { (request) in
                    self.reqSent = false
                    if request.count == 0 {
                        self.scheduleBloodNotification()
                        self.scheduleFoodNotification()
                    }
                }
            }
        }
    }
    internal func performSegueOnRoot(name: String) {
        if DataHolder.token != nil {
            if let root = self.window?.rootViewController as? UINavigationController {
                root.popToRootViewController(animated: false)
                if let home = root.topViewController as? HomePageViewController {
                    home.performSegue(withIdentifier: name, sender: self)
                }
            }
        }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case actionIDVitalLater:
            self.scheduleBloodNotification(laterNotificationPeriod)
            break
        case actionIDVitalUpload:
            performSegueOnRoot(name: "showBloodPressure")
            break
        case actionIDFoodLater:
            self.scheduleFoodNotification(laterNotificationPeriod)
            break
        case actionIDFoodUpload:
            performSegueOnRoot(name: "showFoodDiary")
            break
        default:
            switch response.notification.request.identifier {
            case notificationIDVital:
                performSegueOnRoot(name: "showBloodPressure")
            case notificationIDFood:
                performSegueOnRoot(name: "showFoodDiary")
            default:
                break
            }
            break
        }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // What to do?
    }
    func scheduleBloodNotification(_ time: TimeInterval = notificationPeriod) {
        // Create Notification Content
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationIDVital])
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        //notificationContent.title = "MOYO"
        //notificationContent.subtitle = "Vital"
        notificationContent.body = vitalNote
        notificationContent.sound = UNNotificationSound.default()
        
        // Set Category Identifier
        notificationContent.categoryIdentifier = actionIDVitalCategory
        
        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: notificationPeriod, repeats: false)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: notificationIDVital, content: notificationContent, trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
    func scheduleFoodNotification(_ time: TimeInterval = notificationPeriod) {
        // Create Notification Content
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationIDFood])
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        //notificationContent.title = "MOYO"
        //notificationContent.subtitle = "Food"
        notificationContent.body = foodNote
        notificationContent.sound = UNNotificationSound.default()
        
        // Set Category Identifier
        notificationContent.categoryIdentifier = actionIDFoodCategory
        
        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: notificationPeriod, repeats: false)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: notificationIDFood, content: notificationContent, trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }

}
