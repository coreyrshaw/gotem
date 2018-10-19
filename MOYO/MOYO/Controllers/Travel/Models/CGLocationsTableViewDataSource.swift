//
//  CGLocationsTableViewDataSource.swift
//  CityGuide
//
//  Copyright © 2016 dmbTeam. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreData
import CoreLocation
import GooglePlaces

protocol CGLocationsTableViewDataSourceDelegate: class {
    func didFinishLoading(_ sender: CGLocationsTableViewDataSource)
}

class CGLocationsTableViewDataSource: NSObject, UITableViewDataSource {

    var locations = [CGLocation]()
    var locationImages = [UIImage]()
    var placeholderImage:UIImage!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var location: CLLocation
    
    weak var delegate:CGLocationsTableViewDataSourceDelegate?
    
    init(location: CLLocation) {
        self.location = location
        super.init()
        
        self.loadLocationForKeyWord("")
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: nil, queue: nil) { notiication in
            self.loadLocationForKeyWord("")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationsCell", for: indexPath) as! CGLocationsTableViewCell
            
        let location:CGLocation = locations[(indexPath as NSIndexPath).row]
        
        cell.locationTitlelabel.text = location.locationName
        cell.priceRatingView.priceRating = location.locationPriceRating
        cell.locationRatingView.locationRating = location.locationRating
        
        if location.locationPhotoReference.first != nil {
            let reference = location.locationPhotoReference.first! as String
            let downloadURL = URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(reference)&key=\(Constants.placesApiKey)")!
            cell.locationImageView.af_setImage(withURL: downloadURL, placeholderImage: placeholderImage) { (response) in
                if let image = response.result.value {
                    cell.bluredLocationImageView.image = image
                }
                else {
                    cell.bluredLocationImageView.image = self.placeholderImage
                }
            }
        } else {
            cell.locationImageView.image = placeholderImage
            cell.bluredLocationImageView.image = self.placeholderImage
        }
        
        return cell
    }
    
    func loadLocationForKeyWord(_ keyWord:String) -> Void {
        
        self.locations.removeAll()
        
        if CGLocationsManager.sharedInstance.selectedLocationTypeIsFavorites() {
            
            let managedContext = appDelegate.managedObjectContext
            let fetchRequest = NSFetchRequest<Location>(entityName: "Location")
            
            do {
                let results =
                    try managedContext.fetch(fetchRequest)
                
                for favoritelocation:Location in results {
                    
                    if let locationData = favoritelocation.locationData {
                        let dictionary:NSDictionary? = NSKeyedUnarchiver.unarchiveObject(with: locationData) as? NSDictionary
                        let location:CGLocation = CGLocation(JSON: dictionary!)
                        self.locations.append(location)
                    }
                }
                
                placeholderImage = UIImage(named: "fav_placeholder")
                
                self.delegate?.didFinishLoading(self)
                
                if results.count == 0 {
                    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "showEmptyState"), object: nil)
                    })
                } else {
                    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "hideEmptyState"), object: nil)
                    })
                }
                
            } catch let error as NSError {
                let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "showEmptyState"), object: nil)
                })
                print("Could not fetch \(error), \(error.userInfo)")
            }
            
        } else {
            
            var searchText = ""
            
            if CGLocationsManager.sharedInstance.selectedLocationTypeIsSleep() {
                
                searchText = Constants.searchTextSleep
                placeholderImage = UIImage(named: "sleep_placeholder")
                
            } else if CGLocationsManager.sharedInstance.selectedLocationTypeIsEat() {
                
                searchText = Constants.searchTextEat
                placeholderImage = UIImage(named: "eat_placeholder")
                
            } else if CGLocationsManager.sharedInstance.selectedLocationTypeIsEnjoy() {
                
                searchText = Constants.searchTextEnjoy
                placeholderImage = UIImage(named: "enjoy_placeholder")
                
            }
            
            searchText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            Alamofire.request( "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(location.coordinate.latitude),\(location.coordinate.longitude)&radius=\(Constants.locationsSearchRadius)&type=\(searchText)&keyword=\(keyWord)&key=\(Constants.placesApiKey)", parameters: [:])
                .responseJSON { response in
                    switch response.result {
                    case .success(let JSON):
                        
                        guard let response = JSON as? [String: Any] else {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showEmptyState"), object: nil)
                            return
                        }
                        
                        guard let locationsList = response["results"] as? [Any] else {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showEmptyState"), object: nil)
                            return
                        }
                        
                        for cityLocation in locationsList {
                            let location:CGLocation = CGLocation(JSON: cityLocation as! NSDictionary)
                            if CGLocationsManager.sharedInstance.selectedLocationTypeIsSleep() {
                                self.locations.append(location)
                            } else if (location.locationTypes .contains(Constants.searchTextSleep) == false) {
                                self.locations.append(location)
                            }
                        }
                        
                        if locationsList.count == 0 {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showEmptyState"), object: nil)
                        } else {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideEmptyState"), object: nil)
                        }
                        
                        self.delegate?.didFinishLoading(self)
                        
                    case .failure(let error):
                        print("Request failed with error: \(error)")
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showEmptyState"), object: nil)
                    }
            }
        }
    }
}
