//
//  CGMapViewController.swift
//  CityGuide
//
//  Copyright © 2016 dmbTeam. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import Alamofire
import CoreData

class CGMapViewController: UIViewController, GMSMapViewDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var favoriteLocationsButton: UIButton!
    @IBOutlet weak var sleepLocationsButton: UIButton!
    @IBOutlet weak var eatLocationsButton: UIButton!
    @IBOutlet weak var enjoyLocationsButton: UIButton!
    @IBOutlet weak var locationDetailsView: UIView!
    
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var priceLevelLabel: UILabel!
    @IBOutlet weak var priceLevelView: CGLocationPriceRatingView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingView: CGLocationRatingView!
    @IBOutlet weak var openDetailsButton: UIButton!
    @IBOutlet weak var openDetailsImageView: UIImageView!
    @IBOutlet weak var openDetailsButtonTopBorder: UIView!
    
    var backgroundView:UIView!
    
    var currentLocation :CLLocation? = nil
    
    var location:CGLocation!
    var selectedLocation:CGLocation!
    var favoriteLocation:Location!

    var sleepLocations = [CGLocation]()
    var eatLocations = [CGLocation]()
    var enjoyLocations = [CGLocation]()
    var favoriteLocations = [CGLocation]()
    
    var sleepMarkers = [GMSMarker]()
    var eatMarkers = [GMSMarker]()
    var enjoyMarkers = [GMSMarker]()
    var favoriteMarkers = [GMSMarker]()
    var allMarkers = [GMSMarker]()
    
    let locationManager = CLLocationManager()
    
    var markersAreVisible:Bool = false
    
    var startingLocation: CLLocation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        self.backgroundView = UIView.init(frame: UIScreen.main.bounds)
        self.backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.55)
        self.backgroundView.alpha = 0
        
        let hideLocationDetails = UITapGestureRecognizer(target: self, action: #selector(CGMapViewController.hideDetails(_:)))
        self.backgroundView.addGestureRecognizer(hideLocationDetails)
        
        self.view.insertSubview(self.backgroundView, at: 2)
        
        self.openDetailsButtonTopBorder.backgroundColor = CGColors().borderColor()
        self.openDetailsButton.backgroundColor = CGColors().greyBackgroundColor()
        if let sl = startingLocation {
            setLocation(location: sl)
        }
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func toggleFavoriteLocationsButton(_ sender: UIButton) {
        
        if self.favoriteMarkers.count == 0 {
            
            self.favoriteLocationsButton.setImage(UIImage(named: "map_filter_fav_active"), for: .normal)
            
            let managedContext = appDelegate.managedObjectContext
            let fetchRequest = NSFetchRequest<Location>(entityName: "Location")
            
            do {
                let results =
                    try managedContext.fetch(fetchRequest)
                
                for favoritelocation:Location in results {
                    
                    if let locationData = favoritelocation.locationData {
                        let dictionary:NSDictionary? = NSKeyedUnarchiver.unarchiveObject(with: locationData) as? NSDictionary
                        let location:CGLocation = CGLocation(JSON: dictionary!)
                        self.favoriteLocations.append(location)
                        
                        let position = CLLocationCoordinate2DMake(location.locationLatitude, location.locationLongitude)
                        let marker = GMSMarker(position: position)
                        marker.icon = UIImage(named: "map_pin_fav")
                        marker.map = self.mapView
                        self.favoriteMarkers.append(marker)
                        self.allMarkers.append(marker)
                    }
                }
                
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        } else {
            
            self.favoriteLocationsButton.setImage(UIImage(named: "map_filter_fav"), for: .normal)
            
            for marker:GMSMarker in self.favoriteMarkers {
                let marker = marker
                marker.map = nil;
                self.deleteMarkerFromAllMarkers(marker)
            }
            self.favoriteMarkers.removeAll()
            
        }
    }
    
    @IBAction func toggleSleepLocationsButton(_ sender: UIButton) {
        
        if self.sleepMarkers.count == 0 {
            
            self.sleepLocationsButton.setImage(UIImage(named: "map_filter_sleep_active"), for: .normal)
            
            var latitude : Double
            var longitude : Double
            
            if self.location != nil {
                latitude = self.location.locationLatitude
                longitude = self.location.locationLongitude
            } else {
                
                let center = self.mapView.center
                let coordinates:CLLocationCoordinate2D = self.mapView.projection.coordinate(for: center)
                
                latitude = coordinates.latitude
                longitude = coordinates.longitude
            }
            
            let searchText = Constants.searchTextSleep.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            Alamofire.request("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=\(Constants.locationsSearchRadius)&type=\(searchText)&key=\(Constants.placesApiKey)", parameters: [:])
                .responseJSON { response in
                    switch response.result {
                    case .success(let JSON):
                        
                        let response = JSON as! NSDictionary
                        
                        let locationsList = response["results"] as! NSArray
                        
                        for cityLocation in locationsList {
                            
                            let location:CGLocation = CGLocation(JSON: cityLocation as! NSDictionary)
                            self.sleepLocations.append(location)
                            
                            let position = CLLocationCoordinate2DMake(location.locationLatitude, location.locationLongitude)
                            let marker = GMSMarker(position: position)
                            marker.icon = UIImage(named: "map_pin_sleep")
                            marker.map = self.mapView
                            self.sleepMarkers.append(marker)
                            self.allMarkers.append(marker)
                        }
                        
                    case .failure(let error):
                        print("Request failed with error: \(error)")
                    }
            }
        } else {
            
            self.sleepLocationsButton.setImage(UIImage(named: "map_filter_sleep"), for: .normal)
            
            for marker:GMSMarker in self.sleepMarkers {
                let marker = marker
                marker.map = nil;
                self.deleteMarkerFromAllMarkers(marker)
            }
            self.sleepMarkers.removeAll()
        }
    }
    
    @IBAction func toggleEatLocationsButton(_ sender: UIButton) {
        
        if self.eatMarkers.count == 0 {
            
            self.eatLocationsButton.setImage(UIImage(named: "map_filter_eat_active"), for: .normal)
            
            var latitude : Double
            var longitude : Double

            if self.location != nil {
                latitude = self.location.locationLatitude
                longitude = self.location.locationLongitude
            } else {

                let center = self.mapView.center
                let coordinates:CLLocationCoordinate2D = self.mapView.projection.coordinate(for: center)
                
                latitude = coordinates.latitude
                longitude = coordinates.longitude
            }
            
            var searchText = ""
            
            if let searchedText = Constants.searchTextEat.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                searchText = searchedText
            }
            
            Alamofire.request("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=\(Constants.locationsSearchRadius)&type=\(searchText)&key=\(Constants.placesApiKey)", parameters: [:])
                .responseJSON { response in
                    switch response.result {
                    case .success(let JSON):
                        
                        let response = JSON as! NSDictionary
                        
                        let locationsList = response["results"] as! NSArray
                        
                        for cityLocation in locationsList {
                            
                            let location:CGLocation = CGLocation(JSON: cityLocation as! NSDictionary)
                            self.eatLocations.append(location)
                            
                            let position = CLLocationCoordinate2DMake(location.locationLatitude, location.locationLongitude)
                            let marker = GMSMarker(position: position)
                            marker.icon = UIImage(named: "map_pin_eat")
                            marker.map = self.mapView
                            self.eatMarkers.append(marker)
                            self.allMarkers.append(marker)
                        }
                        
                    case .failure(let error):
                        print("Request failed with error: \(error)")
                    }
            }
        } else {
            
            self.eatLocationsButton.setImage(UIImage(named: "map_filter_eat"), for: .normal)
            
            for marker:GMSMarker in self.eatMarkers {
                let marker = marker
                marker.map = nil;
                self.deleteMarkerFromAllMarkers(marker)
            }
            self.eatMarkers.removeAll()
        }
    }
    
    @IBAction func toggleEnjoyLocationsButton(_ sender: UIButton) {
        
        if self.enjoyLocations.count == 0 {
            
            self.enjoyLocationsButton.setImage(UIImage(named: "map_filter_enjoy_active"), for: .normal)
            
            var latitude : Double
            var longitude : Double

            if self.location != nil {
                latitude = self.location.locationLatitude
                longitude = self.location.locationLongitude
            } else {

                let center = self.mapView.center
                let coordinates:CLLocationCoordinate2D = self.mapView.projection.coordinate(for: center)
                
                latitude = coordinates.latitude
                longitude = coordinates.longitude
            }
            
            var searchText = ""
            
            if let searchedText = Constants.searchTextEnjoy.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                searchText = searchedText
            }
            
            Alamofire.request("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=\(Constants.locationsSearchRadius)&type=\(searchText)&key=\(Constants.placesApiKey)", parameters: [:])
                .responseJSON { response in
                    switch response.result {
                    case .success(let JSON):
                        
                        let response = JSON as! NSDictionary
                        
                        let locationsList = response["results"] as! NSArray
                        
                        for cityLocation in locationsList {
                            
                            let location:CGLocation = CGLocation(JSON: cityLocation as! NSDictionary)
                            self.enjoyLocations.append(location)
                            
                            let position = CLLocationCoordinate2DMake(location.locationLatitude, location.locationLongitude)
                            let marker = GMSMarker(position: position)
                            marker.icon = UIImage(named: "map_pin_enjoy")
                            marker.map = self.mapView
                            self.enjoyMarkers.append(marker)
                            self.allMarkers.append(marker)
                        }
                        
                    case .failure(let error):
                        print("Request failed with error: \(error)")
                    }
            }
        } else {
            
            self.enjoyLocationsButton.setImage(UIImage(named: "map_filter_enjoy"), for: .normal)
            
            for marker:GMSMarker in self.enjoyMarkers {
                let marker = marker
                marker.map = nil;
                self.deleteMarkerFromAllMarkers(marker)
            }
            self.enjoyMarkers.removeAll()
        }
    }
    
    @IBAction func toggleOpenDetailsButton(_ sender: UIButton) {
        let vc = CGLocationDetailsViewController(nibName: "CGLocationDetailsViewController", bundle: nil)
        vc.location = self.selectedLocation
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if self.sleepMarkers.contains(marker) {
            self.presentSelectedLocation(self.sleepLocations[self.sleepMarkers.index(of: marker)!])
            self.openDetailsImageView.image = UIImage(named: "ic_map_more_sleep")
        } else if self.eatMarkers.contains(marker) {
            self.presentSelectedLocation(self.eatLocations[self.eatMarkers.index(of: marker)!])
            self.openDetailsImageView.image = UIImage(named: "ic_map_more_eat")
        } else if self.enjoyMarkers.contains(marker) {
            self.presentSelectedLocation(self.enjoyLocations[self.enjoyMarkers.index(of: marker)!])
            self.openDetailsImageView.image = UIImage(named: "ic_map_more_enjoy")
        } else if self.favoriteMarkers.contains(marker) {
            self.presentSelectedLocation(self.favoriteLocations[self.favoriteMarkers.index(of: marker)!])
            self.openDetailsImageView.image = UIImage(named: "ic_map_more_fav")
        }
        
        return true
    }
    
    @objc func hideDetails(_ sender:UITapGestureRecognizer){
        UIView.animate(withDuration: 0.5, animations: {
            self.backgroundView.alpha = 0
            self.locationDetailsView.alpha = 0
            }, completion: { finished in
        })
    }
    
    func presentSelectedLocation(_ maplocation:CGLocation) -> Void {
        
        self.selectedLocation = maplocation
        
        self.locationDetailsView.layer.cornerRadius = 5
        self.locationDetailsView.clipsToBounds = true
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.backgroundView.alpha = 1
            self.locationDetailsView.alpha = 1
            if let photoReference = self.selectedLocation.locationPhotoReference.first {
                if let url = URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(photoReference)&key=\(Constants.placesApiKey)") {
                    let downloadURL = url
                    self.detailsImageView.af_setImage(withURL: downloadURL, placeholderImage: nil)
                }
            }
            self.locationNameLabel.text = self.selectedLocation.locationName
            self.priceLevelLabel.text = NSLocalizedString("PriceRatingKey", comment: "Price Rating Label")
            self.priceLevelView.priceRating = self.selectedLocation.locationPriceRating
            self.ratingLabel.text = NSLocalizedString("RatingKey", comment: "Rating Label")
            self.ratingView.locationRating = self.selectedLocation.locationRating
            self.openDetailsButton.setTitle(NSLocalizedString("LocationDetailsButtonTitleKey", comment: "location details button title"), for: .normal)
            }, completion: { finished in
        })
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
      
        let zoomLevel = self.mapView.camera.zoom

        if zoomLevel < 12 {
            
            if allMarkers.count > 0 {
                self.mapView.clear()
                markersAreVisible = false
            }

        } else {
            
            if allMarkers.count > 0 && !markersAreVisible {
                markersAreVisible = true
                for marker in self.allMarkers {
                    marker.map = self.mapView
                }
            }
        }
    }
    
    func deleteMarkerFromAllMarkers(_ element: GMSMarker) {
        self.allMarkers = self.allMarkers.filter() { $0 !== element }
    }
}

extension CGMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            
            locationManager.startUpdatingLocation()
            
            if CGLocationsManager.sharedInstance.selectedLocationTypeIsSleep() && self.location == nil && self.sleepLocations.count > 0 {
                
                self.sleepLocationsButton.setImage(UIImage(named: "map_filter_sleep_active"), for: .normal)
                
                for location in self.sleepLocations {
                    
                    let position = CLLocationCoordinate2DMake(location.locationLatitude, location.locationLongitude)
                    let marker = GMSMarker(position: position)
                    marker.icon = UIImage(named: "map_pin_sleep")
                    marker.map = self.mapView
                    self.sleepMarkers.append(marker)
                    self.allMarkers.append(marker)
                }
                
                mapView.camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2DMake(self.sleepLocations[0].locationLatitude, self.sleepLocations[0].locationLongitude), zoom: 13)
                
            } else if CGLocationsManager.sharedInstance.selectedLocationTypeIsEat() && self.location == nil && self.eatLocations.count > 0 {
                
                self.eatLocationsButton.setImage(UIImage(named: "map_filter_eat_active"), for: .normal)
                
                for location in self.eatLocations {
                    
                    let position = CLLocationCoordinate2DMake(location.locationLatitude, location.locationLongitude)
                    let marker = GMSMarker(position: position)
                    marker.icon = UIImage(named: "map_pin_eat")
                    marker.map = self.mapView
                    self.eatMarkers.append(marker)
                    self.allMarkers.append(marker)
                }
                
                mapView.camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2DMake(self.eatLocations[0].locationLatitude, self.eatLocations[0].locationLongitude), zoom: 13)
                
            } else if CGLocationsManager.sharedInstance.selectedLocationTypeIsEnjoy() && self.location == nil && self.enjoyLocations.count > 0 {
                
                self.enjoyLocationsButton.setImage(UIImage(named: "map_filter_enjoy_active"), for: .normal)
                
                for location in self.enjoyLocations {
                    
                    let position = CLLocationCoordinate2DMake(location.locationLatitude, location.locationLongitude)
                    let marker = GMSMarker(position: position)
                    marker.icon = UIImage(named: "map_pin_enjoy")
                    marker.map = self.mapView
                    self.enjoyMarkers.append(marker)
                    self.allMarkers.append(marker)
                }
                
                mapView.camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2DMake(self.enjoyLocations[0].locationLatitude, self.enjoyLocations[0].locationLongitude), zoom: 13)
                
            } else if CGLocationsManager.sharedInstance.selectedLocationTypeIsFavorites() && self.location == nil && self.favoriteLocations.count > 0 {
                
                self.favoriteLocationsButton.setImage(UIImage(named: "map_filter_fav_active"), for: .normal)
                
                for location in self.favoriteLocations {
                    
                    let position = CLLocationCoordinate2DMake(location.locationLatitude, location.locationLongitude)
                    let marker = GMSMarker(position: position)
                    marker.icon = UIImage(named: "map_pin_fav")
                    marker.map = self.mapView
                    self.favoriteMarkers.append(marker)
                    self.allMarkers.append(marker)
                }
                
                mapView.camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2DMake(self.favoriteLocations[0].locationLatitude, self.favoriteLocations[0].locationLongitude), zoom: 13)
                
            } else if self.location != nil {
                
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2DMake(self.location.locationLatitude, self.location.locationLongitude)
                marker.map = self.mapView
                mapView.camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: 13)
                self.allMarkers.append(marker)
            }
            
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
            
            markersAreVisible = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            currentLocation = location
            
            if self.location == nil && sleepLocations.count == 0 && eatLocations.count == 0 && enjoyLocations.count == 0 && favoriteLocations.count == 0 {
                setLocation(location: location)
            }
            
            locationManager.stopUpdatingLocation()
        }
    }
    func setLocation(location: CLLocation) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        marker.map = self.mapView
        mapView.camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: 13)
    }
}
