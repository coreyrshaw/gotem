//
//  Constants.swift
//
//  Created by Corey S on 31/07/18.
//  Copyright © 2018 Moyo. All rights reserved.
//

import Foundation
import Alamofire

class WeatherService
{
    // Sample url: https://api.darksky.net/forecast/33c371344898311931ea3058dcc4730f/37.8267,-122.4233
    
    let weatherAPIKey: String
    let weatherBaseURL: URL?
    
    init(APIKey: String)
    {
        self.weatherAPIKey = APIKey
        weatherBaseURL = URL(string: "https://api.darksky.net/forecast/\(APIKey)")
    }
    
    func getCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (CurrentWeather?) -> Void)
    {
        if let forecastURL = URL(string: "\(weatherBaseURL!)/\(latitude),\(longitude)") {
            
            Alamofire.request(forecastURL).responseJSON(completionHandler: { (response) in
                if let jsonDictionary = response.result.value as? [String : Any] {
                    if let currentWeatherDictionary = jsonDictionary["currently"] as? [String : Any] {
                        let currentWeather = CurrentWeather(weatherDictionary: currentWeatherDictionary)
                        completion(currentWeather)
                        return
                    }
                }
                completion(nil)
            })
        }
        
    }
}
