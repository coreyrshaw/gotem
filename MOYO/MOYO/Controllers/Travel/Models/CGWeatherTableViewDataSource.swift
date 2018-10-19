//
//  CGWeatherTableViewDataSource.swift
//  CityGuide
//
//  Copyright © 2016 dmbTeam. All rights reserved.
//

import UIKit
import Alamofire

protocol CGWeatherTableViewDataSourceDelegate: class {
    func didFinishLoading(_ sender: CGWeatherTableViewDataSource)
}

class CGWeatherTableViewDataSource: NSObject, UITableViewDataSource {
    
    var dailyForecasts = [CGDailyForecast]()
    
    weak var delegate:CGWeatherTableViewDataSourceDelegate?

    override init() {
        
        super.init()

        Alamofire.request( "http://api.openweathermap.org/data/2.5/forecast/daily?q=\(NSLocalizedString("CountryKey", comment: "city name"))&units=metric&APPID=\(Constants.weatherApiKey)", parameters: [:])
            .responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    
                    let data = JSON as! NSDictionary
                    
                    if let forecastsList = data["list"] as? [NSDictionary] {
                        for forecast in forecastsList {
                            let dailyForecast:CGDailyForecast = CGDailyForecast(JSON: forecast)
                            self.dailyForecasts.append(dailyForecast)
                        }
                    }
                    
                    self.delegate?.didFinishLoading(self)
                    
                case .failure(let erorrString):
                    
                    print("Request failed with error: \(erorrString)")
                }
        }
    }
    
    func convertStringToDictionary(_ text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyForecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! CGWeatherTableViewCell
        
        let forecast = dailyForecasts[(indexPath as NSIndexPath).row]
        
        cell.forecastDateLabel.text  = forecast.feracastDate
        cell.forecastValueLabel.text = forecast.forecastCondition
        cell.forecastTextLabel.text  = forecast.forecastText
        cell.forecastImageView.image = forecast.forecastIcon 
        
        if (indexPath as NSIndexPath).row % 2 == 0 {
            cell.forecastLeadingConstraint.constant = UIScreen.main.bounds.size.width - 180 // 170 for forecastDateLabel size and extra 10 for space
        } else {
            cell.forecastLeadingConstraint.constant = 10
        }
        
        return cell
    }
}
