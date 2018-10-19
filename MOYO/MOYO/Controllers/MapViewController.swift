//
//  Map.swift
//  MOYO
//
//  Created by Corey S on 8/1/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import UIKit
import GoogleMaps

protocol GetLocationData: class {
    func getLocationsFromMapVC(locations: [CurrentLocation])
}

class MapVC: UIViewController, GMSMapViewDelegate {
    
    var mapView = GMSMapView()
    var locationManager = CLLocationManager()
    var homeDelegate: TravelViewController?
    // "location" object used in HomeVC class
    var location: CLLocationCoordinate2D?
    var locations = [CurrentLocation]()
    
    weak var delegate: GetLocationData?
    
    
    //MARK:- VIEW CONTROLLER METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        locationManager.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        //x,y,height, width
        
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        mapView.delegate = self
        checkAuthStatus()
        
        print("Dele: \(delegate)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let homeVC = homeDelegate {
            //homeVC.mapVC = self
        }
        
        self.view.layoutIfNeeded()
        
    }
    
    //MARK:- CORE FUNCTIONS
    
    func checkAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
        }
        else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func showMap(coordinate: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 12.0)
       // mapView.camera = camera
                mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        //
               view = mapView
        mapView.isMyLocationEnabled = true
        //showMarkersAndInfoList()
    }
    
    func showMarkersAndInfoList() {
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("Marker Tap")
        mapView.selectedMarker = marker
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("Marker Info Window Tap")
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        print("Marker Info Window")
        let markerView = MapMarkerInfoWindow(frame: CGRect(x: 0, y: 0, width: 150, height: 60))
        markerView.label.text = marker.title
        
        return markerView
    }
    
    @objc func markerAction(){
        print("Marker Btn Pressed")
    }
    
}

extension MapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
        
        if status == .authorizedAlways{
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        locationManager.stopUpdatingLocation()
        showMap(coordinate: location.coordinate)
        self.location = location.coordinate
        
    }
}
