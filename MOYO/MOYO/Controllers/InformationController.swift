//
//  ViewController.swift
//  MOYO
//
//  Created by Christopher Myers on 6/19/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class InformationController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var latLongLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var polutionLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var weatherService: WeatherService!
    var pollutionService: PollutionService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        enableLocationServices()
    }
 
    func enableLocationServices() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            disableMyLocationBasedFeatures()
        case .authorizedWhenInUse:
            enableMyWhenInUseFeatures()
        case .authorizedAlways:
            enableMyWhenInUseFeatures()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            disableMyLocationBasedFeatures()
        case .authorizedWhenInUse:
            enableMyWhenInUseFeatures()
        case .authorizedAlways:
            enableMyWhenInUseFeatures()
        case .notDetermined:
            break
        }
    }

    
    // Get last location and make call for weather
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //DATA TO COLLECT:  "\(lastLocation.coordinate.latitude), \(lastLocation.coordinate.longitude)"
        let lastLocation = locations.last!
        print(lastLocation)
        print(lastLocation.coordinate)
        print(lastLocation.timestamp)
        latLongLabel.text = "\(lastLocation.coordinate.latitude), \(lastLocation.coordinate.longitude)"
        updateWeatherForLocation(location: lastLocation)
    }
    
    
    func updateWeatherForLocation (location: CLLocation) {
        //DATA TO COLLECT: currentWeather.temperature
        weatherService = WeatherService(APIKey: weatherAPIKey)
        weatherService.getCurrentWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { (currentWeather) in
            if let currentWeather = currentWeather {
                DispatchQueue.main.async {
                    if let temperature = currentWeather.temperature {
                        self.temperatureLabel.text = "\(temperature)°"
                    } else {
                        self.temperatureLabel.text = "sorry"
                        print("could not get")
                    }
                }
            }
        }
    }
    
    
    func disableMyLocationBasedFeatures() {
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    func enableMyWhenInUseFeatures() {
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
}
