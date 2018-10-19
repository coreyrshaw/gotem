//
//  CGLocationDetailsViewController.swift
//  CityGuide
//
//  Copyright © 2016 dmbTeam. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class CGLocationDetailsViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var locationImagesScrollView: CGLocationImagesScrollView!
    @IBOutlet weak var locationAddressLabel: UILabel!
    @IBOutlet weak var locationAddressValueLabel: UILabel!
    @IBOutlet weak var locationPhoneLabel: UILabel!
    @IBOutlet weak var locationPhoneValueLabel: UILabel!
    @IBOutlet weak var locationTagsLabel: UILabel!
    @IBOutlet weak var locationTagsScrollView: CGLocationTagsScrollView!
    @IBOutlet weak var priceRatingLabel: UILabel!
    @IBOutlet weak var priceRatingView: CGLocationPriceRatingView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingView: CGLocationRatingView!
    
    @IBOutlet weak var showMapButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationPhotosCountLabel: UILabel!
    @IBOutlet weak var viewLocationReviewsButton: UIButton!
    @IBOutlet weak var addToFavoritesButton: UIButton!
    
    @IBOutlet var coloredLabels: [UILabel]!
    
    var location:CGLocation!
    var favoriteLocation:Location!
    var imageList = [String]()
    var reviewsList = [CGLocationReview]()
    var locationsIDs = [String]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationImagesScrollView.delegate = self
        
        self.addBlurToLocationNameContainer()
        
        self.locationNameLabel.text = location.locationName
        
        priceRatingLabel.text = NSLocalizedString("PriceRatingKey", comment: "Price Rating Label")
        priceRatingView.priceRating = location.locationPriceRating
        
        ratingLabel.text = NSLocalizedString("RatingKey", comment: "Rating Label")
        ratingView.locationRating = location.locationRating
        
        setTitle()
        getLocationDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getFavoriteLocationsList()
        self.setUp()
    }
    
    @IBAction func toggleCallButton(_ sender: UIButton) {
        
        let phoneNumber:String = String(format: "tel://%@", self.locationPhoneValueLabel.text!.replacingOccurrences(of: " ", with: ""))
        
        if let phoneCallURL:URL = URL(string:phoneNumber) {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
    }
    
    @IBAction func toggleShowMapButton(_ sender: UIButton) {
        let mapVC = CGMapViewController(nibName: "CGMapViewController", bundle: nil)
        if self.location != nil {
            mapVC.location = location
        } else {
            mapVC.favoriteLocation = favoriteLocation
        }
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    @IBAction func toggleViewLocationReviewsButton(_ sender: UIButton) {
        let reviewsVC = CGLocationReviewsViewController(nibName: "CGLocationReviewsViewController", bundle: nil)
        reviewsVC.reviewsList = self.reviewsList
        self.navigationController?.pushViewController(reviewsVC, animated: true)
    }
    
    @IBAction func toggleAddToFavoritesButton(_ sender: UIButton) {
        
        if locationsIDs.contains(self.location.locationID) {
                
            let context:NSManagedObjectContext = appDelegate.managedObjectContext
            
            let locationsFetchRequest = NSFetchRequest<Location>(entityName: "Location")
            
            do {
                let results =
                    try context.fetch(locationsFetchRequest)
                
                for favoritelocation:Location in results {
                    
                    if let locationData = favoritelocation.locationData {
                        let dictionary:NSDictionary? = NSKeyedUnarchiver.unarchiveObject(with: locationData) as? NSDictionary
                        if let json = dictionary {
                            let favLocation:CGLocation = CGLocation(JSON: json)
                            
                            if favLocation.locationID == self.location.locationID  {
                                if let index = results.index(of: favoritelocation) {
                                    context.delete(results[index])
                                }
                            }
                        }
                    }
                }
                
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
            
            let idsFetchRequest = NSFetchRequest<FavoriteLocationID>(entityName: "FavoriteLocationID")
            
            do {
                let results =
                    try context.fetch(idsFetchRequest)
                
                for locationID in results {
                    
                    let locID:FavoriteLocationID = locationID
                    
                    if locID.locationID == self.location.locationID  {
                        if let index = results.index(of: locationID) {
                            self.locationsIDs.remove(at: index)
                            context.delete(locationID)
                        }
                    }
                }
                
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
            
            do {
                try context.save()
            } catch _ {
            }
        } else {
            let managedContext = appDelegate.managedObjectContext
            
            let entity =  NSEntityDescription.entity(forEntityName: "Location", in:managedContext)
            
            let selectedLocation:Location = NSManagedObject(entity: entity!, insertInto: managedContext) as! Location
            
            selectedLocation.locationData = self.location.locationData

            let idEntity =  NSEntityDescription.entity(forEntityName: "FavoriteLocationID", in:managedContext)
            
            let selectedLocationID:FavoriteLocationID = NSManagedObject(entity: idEntity!, insertInto: managedContext) as! FavoriteLocationID
            
            selectedLocationID.locationID = self.location.locationID
            
            do {
                try managedContext.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
        
        self.getFavoriteLocationsList()
        self.setUpAddToFavoritesButton()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        self.locationImagesScrollView.contentOffset.y = 0.0
        let currentPage:Int = Int((self.locationImagesScrollView.contentOffset.x+(0.5*self.locationImagesScrollView.frame.size.width))/self.locationImagesScrollView.frame.width)+1
        self.locationPhotosCountLabel.text = String(format: "%d of %d", currentPage, self.imageList.count)
    }
    
    func setUp() -> Void {
        if CGLocationsManager.sharedInstance.selectedLocationTypeIsSleep() {
            showMapButton.setImage(UIImage(named: "ic_sleep_map"), for: .normal)
            callButton.setImage(UIImage(named: "ic_sleep_call"), for: .normal)
            viewLocationReviewsButton.setImage(UIImage(named: "ic_sleep_view"), for: .normal)
        } else if CGLocationsManager.sharedInstance.selectedLocationTypeIsEat() {
            showMapButton.setImage(UIImage(named: "ic_eat_map"), for: .normal)
            callButton.setImage(UIImage(named: "ic_eat_call"), for: .normal)
            viewLocationReviewsButton.setImage(UIImage(named: "ic_eat_view"), for: .normal)
        } else if CGLocationsManager.sharedInstance.selectedLocationTypeIsEnjoy() {
            showMapButton.setImage(UIImage(named: "ic_enjoy_map"), for: .normal)
            callButton.setImage(UIImage(named: "ic_enjoy_call"), for: .normal)
            viewLocationReviewsButton.setImage(UIImage(named: "ic_enjoy_view"), for: .normal)
        } else {
            showMapButton.setImage(UIImage(named: "ic_fav_map"), for: .normal)
            callButton.setImage(UIImage(named: "ic_fav_call"), for: .normal)
            viewLocationReviewsButton.setImage(UIImage(named: "ic_fav_view"), for: .normal)
        }
        
        self.setUpAddToFavoritesButton()
        
        for label in coloredLabels {
            label.textColor = CGColors().colorForCurrentLocationType()
        }
    }
    
    func addBlurToLocationNameContainer() -> Void {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = containerView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.insertSubview(blurEffectView, at: 0)
    }
    
    func setUpAddToFavoritesButton() -> Void {
        if locationsIDs.contains(self.location.locationID) {
            if CGLocationsManager.sharedInstance.selectedLocationTypeIsSleep() {
                addToFavoritesButton.setImage(UIImage(named: "sleep_fav_full"), for: .normal)
            } else if CGLocationsManager.sharedInstance.selectedLocationTypeIsEat() {
                addToFavoritesButton.setImage(UIImage(named: "eat_fav_full"), for: .normal)
            } else if CGLocationsManager.sharedInstance.selectedLocationTypeIsEnjoy() {
                addToFavoritesButton.setImage(UIImage(named: "enjoy_fav_full"), for: .normal)
            } else {
                addToFavoritesButton.setImage(UIImage(named: "fav_full"), for: .normal)
            }
        } else {
            if CGLocationsManager.sharedInstance.selectedLocationTypeIsSleep() {
                addToFavoritesButton.setImage(UIImage(named: "sleep_fav_empty"), for: .normal)
            } else if CGLocationsManager.sharedInstance.selectedLocationTypeIsEat() {
                addToFavoritesButton.setImage(UIImage(named: "eat_fav_empty"), for: .normal)
            } else if CGLocationsManager.sharedInstance.selectedLocationTypeIsEnjoy() {
                addToFavoritesButton.setImage(UIImage(named: "enjoy_fav_empty"), for: .normal)
            } else {
                addToFavoritesButton.setImage(UIImage(named: "fav_empty"), for: .normal)
            }
        }
    }
    
    func getFavoriteLocationsList() -> Void {
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<FavoriteLocationID>(entityName: "FavoriteLocationID")
        
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            
            for locationID in results {
                
                let locationID:FavoriteLocationID = locationID
                if let locID = locationID.locationID {
                    locationsIDs.append(locID)
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func getLocationDetails() {
        Alamofire.request("https://maps.googleapis.com/maps/api/place/details/json?placeid=\(location.locationID)&key=\(Constants.placesApiKey)", parameters: [:])
            .responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    guard let jsonResponse = JSON as? [String: Any] else {
                        print("error getting jeson")
                        return
                    }
                    guard let response = jsonResponse["result"] as? NSDictionary else {
                        if let status = jsonResponse["status"] {
                            print ("request error status: \(status)")
                        }
                        return
                    }
                    
                    self.locationAddressLabel.text = NSLocalizedString("AddressKey", comment: "location address")
                    self.locationAddressValueLabel.text = response["formatted_address"] as? String
                    
                    self.locationPhoneLabel.text = NSLocalizedString("PhoneKey", comment: "phone key")
                    self.locationPhoneValueLabel.text = response["formatted_phone_number"] as? String
                    
                    self.locationTagsScrollView.tagsList = response["types"] as! NSArray
                    self.locationTagsScrollView.setUpTags()
                    
                    if let photos = response["photos"] as? [NSDictionary] {
                        self.imageList = [String]()
                        
                        for photo in photos {
                            
                            let photoReference:String = photo["photo_reference"] as! String
                            self.imageList.append(photoReference)
                        }
                    }
                    
                    self.locationPhotosCountLabel.text = self.imageList.count > 0 ? String(format: "1 of %d", self.imageList.count) : String(format: "0 of 0")
                    self.locationImagesScrollView.imagesList = self.imageList as NSArray
                    self.locationImagesScrollView.setUpImages(self.locationImagesScrollView.frame)
                    
                    if let locationReviewsList = response["reviews"] as? NSArray {
                        for locationReview in locationReviewsList {
                            
                            let review:CGLocationReview = CGLocationReview(JSON: locationReview as! NSDictionary)
                            self.reviewsList.append(review)
                        }
                    }
                    
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    
    func setTitle() -> Void {
        
        var title = ""
        let nameArray = location.locationName.split{$0 == " "}.map(String.init)
        
        for word in nameArray {
            title = title + " " + word
            if title.count < 18 {
                self.title = title
            }
        }
    }
}
