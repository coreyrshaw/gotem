//
//  TravelViewController.swift
//  CityGuide
//
//  Copyright © 2016 dmbTeam. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

let forecastImages: [String: UIImage] =
[
    "clear-day": #imageLiteral(resourceName: "forecast_01d"),
    "clear-night": #imageLiteral(resourceName: "forecast_01n"),
    "rain": #imageLiteral(resourceName: "forecast_09d"),
    "snow": #imageLiteral(resourceName: "forecast_13d"),
    "sleet": #imageLiteral(resourceName: "forecast_11n"), // not found icon for sleet
    "wind": #imageLiteral(resourceName: "forecast_11d"), // not found icon for wind
    "fog": #imageLiteral(resourceName: "forecast_11d"), // not found icon for fog
    "cloudy": #imageLiteral(resourceName: "forecast_03d"),
    "partly-cloudy-day": #imageLiteral(resourceName: "forecast_02d"),
    "partly-cloudy-night":  #imageLiteral(resourceName: "forecast_02n")
]

class TravelViewController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var sleepLabel: UILabel!
    @IBOutlet weak var eatLabel: UILabel!
    @IBOutlet weak var enjoyLabel: UILabel!
    
    @IBOutlet weak var aroundMeButton: UIButton!
    
    var locations = [CGLocation]()
    
    var cityLocation: CLLocation?
    var menu:UIView! = nil
    var upArrow: UIImageView! = nil
    
    let locationController = CLLocationManager()
    
    
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var weatherBorder: UIView!
    @IBOutlet weak var weatherContainer: UIStackView!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    
    var weather: CurrentWeather? = nil {
        didSet {
            guard let summary = weather?.summary, let icon = weather?.icon else {
                weatherLabel.text = nil
                weatherImageView.image = #imageLiteral(resourceName: "ic_no_weather")
                return
            }
            weatherLabel.text = summary.capitalized
            weatherImageView.image = forecastImages[icon]
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("HomeScreenTitleKey", comment: "Home screen title")
        
        self.setUp()
        self.addMenu()
        aboutButton.addTarget(self, action: #selector(TravelViewController.openAbout(_:)), for: .touchUpInside)
        locationController.delegate = self
        locationController.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.closeMenu()
    }
    func openMenu() {
        self.upArrow.isHidden = false
        self.menu.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.upArrow.alpha = 1
            self.menu.frame = CGRect(x: self.view.frame.width - 143, y: 80, width: 120, height: 61)
            self.menu.alpha = 1
        })
    }
    
    func closeMenu() {
        UIView.animate(withDuration: 0.3, animations: {
            
            self.upArrow.alpha = 0
            self.menu.frame = CGRect(x: self.view.frame.width - 143, y: 80, width: 120, height: 20)
            self.menu.alpha = 0
            
            }, completion: { finished in
                self.upArrow.isHidden = true
                self.menu.isHidden = true
            }
        )
    }
    func updateWeather(location: CLLocation) {
        let weatherService = WeatherService(APIKey: weatherAPIKey)
        weatherService.getCurrentWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { (currentWeather) in
            self.weather =  currentWeather
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        closeMenu()
    }
    
    @objc func showFavorites(_ sender: UIButton!) {
        CGLocationsManager.sharedInstance.selectedLocationsType = Constants.locationTypeFavorites
        self.performSegue(withIdentifier: "showLocations", sender: self)
    }
    
    @objc func rateApp(_ sender: UIButton!) {
        UIApplication.shared.openURL(URL(string : "itms-apps://itunes.apple.com/app/\(Constants.appId)")!)
    }
    
    @IBAction func toggleOpenSleepLocationsButton(_ sender: UIButton) {
        guard let _ = cityLocation else {
            self.showError(message: NSLocalizedString("No current location detected", comment: "no loc"))
            return
        }
        CGLocationsManager.sharedInstance.selectedLocationsType = Constants.locationTypeSleep
        self.performSegue(withIdentifier: "showLocations", sender: self)
    }
    
    @IBAction func toggleOpenEatLocationsButton(_ sender: UIButton) {
        guard let _ = cityLocation else {
            self.showError(message: NSLocalizedString("No current location detected", comment: "no loc"))
            return
        }
        CGLocationsManager.sharedInstance.selectedLocationsType = Constants.locationTypeEat
        self.performSegue(withIdentifier: "showLocations", sender: self)
    }
    
    @IBAction func toggleOpenEnjoyLocationsButton(_ sender: UIButton) {
        guard let _ = cityLocation else {
            self.showError(message: NSLocalizedString("No current location detected", comment: "no loc"))
            return
        }
        CGLocationsManager.sharedInstance.selectedLocationsType = Constants.locationTypeEnjoy
        self.performSegue(withIdentifier: "showLocations", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLocations" {
            if let vc = segue.destination as? CGLocationsViewController {
                vc.cityLocation = self.cityLocation!
            }
        }
    }
    // MARK: actions
    @IBAction func toggleFav(_ sender: Any) {
        menu.isHidden ? openMenu() : closeMenu()
    }

    @objc func openWeather(_ sender:UITapGestureRecognizer){
        self.performSegue(withIdentifier: "showWeather", sender: self)
    }
    
    @objc func openAbout(_ sender:UITapGestureRecognizer){
        self.performSegue(withIdentifier: "showAbout", sender: self)
    }
    
    @IBAction func toggleAroundMeButton(_ sender: UIButton) {
        CGLocationsManager.sharedInstance.selectedLocationsType = ""
        let mapVC = CGMapViewController(nibName: "CGMapViewController", bundle: nil)
        mapVC.startingLocation = cityLocation
        mapVC.title = NSLocalizedString("Around Me?", comment: "Around Me?")
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    func addMenu() {
        
        menu = UIView.init(frame: CGRect(x: self.view.frame.width - 145, y: 80, width: 120, height: 61))
        menu.alpha = 0
        menu.isHidden = true
        menu.isUserInteractionEnabled = true
        menu.backgroundColor = CGColors().greyBackgroundColor()
        menu.layer.cornerRadius = 5.0
        menu.layer.borderColor = UIColor.black.cgColor
        menu.clipsToBounds = true
        
        let favoritesButton = UIButton()
        favoritesButton.frame = CGRect(x: 10, y: 0, width: 100, height: 30)
        favoritesButton.setTitleColor(UIColor.black, for: .normal)
        favoritesButton.setTitle(NSLocalizedString("FavoritesTitleKey", comment: "open favorites button"), for: .normal)
        favoritesButton.titleLabel!.font =  UIFont(name: "Helvetica Light", size: 14)
        favoritesButton.addTarget(self, action: #selector(TravelViewController.showFavorites(_:)), for: .touchUpInside)
        menu.addSubview(favoritesButton)
        
        let borderView = UIView()
        borderView.frame = CGRect(x: 0, y: 30, width: 120, height: 1)
        borderView.backgroundColor = CGColors().borderColor()
        menu.addSubview(borderView)
        
        let rateButton = UIButton()
        rateButton.frame = CGRect(x: 10, y: 31, width: 100, height: 30)
        rateButton.setTitleColor(UIColor.black, for: .normal)
        rateButton.setTitle(NSLocalizedString("RateAppKey", comment: "open favorites button"), for: .normal)
        rateButton.titleLabel!.font =  UIFont(name: "Helvetica Light", size: 14)
        rateButton.addTarget(self, action: #selector(TravelViewController.rateApp(_:)), for: .touchUpInside)
        menu.addSubview(rateButton)
        
        view.addSubview(menu)
        
        upArrow = UIImageView.init(image: UIImage(named: "arrow_up"))
        upArrow.frame = CGRect(x: self.view.frame.width - 46, y: 61, width: 20, height: 20)
        upArrow.backgroundColor = UIColor.clear
        upArrow.alpha = 0
        upArrow.isHidden = true
        view.addSubview(upArrow)
    }
    
    func setUp() {
        
        cityLabel.text = NSLocalizedString("Locating...", comment: "home view city label")
        countryLabel.text = NSLocalizedString("Locating...", comment: "home view country label")
        
        sleepLabel.text = NSLocalizedString("SleepKey", comment: "Sleep label text")
        eatLabel.text = NSLocalizedString("EatKey", comment: "Eat label text")
        enjoyLabel.text = NSLocalizedString("EnjoyKey", comment: "Enjoy label text")
        
        aboutButton.setTitle(NSLocalizedString("AboutKey", comment: "About button text"), for: .normal)
        self.aroundMeButton.setTitle(NSLocalizedString("AroundMeKey", comment: "home view around me button title"), for: .normal)
        
        aroundMeButton.layer.cornerRadius = 5
        aroundMeButton.layer.borderWidth = 2
        aroundMeButton.layer.borderColor = UIColor.black.cgColor
        aroundMeButton.clipsToBounds = true
        
        aboutButton.layer.cornerRadius = 0
        aboutButton.layer.borderWidth = 2
        aboutButton.layer.borderColor = UIColor.black.cgColor
        aboutButton.clipsToBounds = true
        
        weatherBorder.layer.cornerRadius = 0
        weatherBorder.layer.borderWidth = 2
        weatherBorder.layer.borderColor = UIColor.black.cgColor
        weatherBorder.clipsToBounds = true
        
        
    }
}
extension TravelViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            cityLabel.text = NSLocalizedString("Unknown City", comment: "")
            countryLabel.text = NSLocalizedString("Unknown Country", comment: "")
            return
        }
        self.cityLocation = location
        self.updateWeather(location: location)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (marks, error) in
            if let error = error {
                self.showError(message: error.localizedDescription)
            }
            else {
                if let mark = marks?.first {
                    self.cityLabel.text = mark.locality
                    self.countryLabel.text = mark.country
                }
                else {
                    self.cityLabel.text = NSLocalizedString("Unknown City", comment: "")
                    self.countryLabel.text = NSLocalizedString("Unknown Country", comment: "")
                }
            }
        }
        self.locationController.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}
