//
//  CurrentWeather.swift
//  MOYO
//
//  Created by Corey.S on 7/26/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import Foundation

class CurrentWeather
{
    let temperature: Int?
    let humidity: Int?
    let precipProbability: Int?
    let summary: String?
    let icon: String?
    
    struct WeatherKeys {
        static let temperature = "temperature"
        static let humidity = "humidity"
        static let precipProbability = "precipProbability"
        static let summary = "summary"
        static let icon = "icon"
    }
    
    init(weatherDictionary: [String : Any])
    {
        if let td = weatherDictionary[WeatherKeys.temperature] as? Double, td.isFinite {
            temperature = Int(round(td))
        }
        else {
            temperature = nil
        }
        
        if let humidityDouble = weatherDictionary[WeatherKeys.humidity] as? Double {
            humidity = Int(humidityDouble * 100)
        } else {
            humidity = nil
        }
        
        if let precipDouble = weatherDictionary[WeatherKeys.precipProbability] as? Double {
            precipProbability = Int(precipDouble * 100)
        } else {
            precipProbability = nil
        }
        
        summary = weatherDictionary[WeatherKeys.summary] as? String
        icon = weatherDictionary[WeatherKeys.icon] as? String
    }
    
    /*
     time: 1497234031,
     summary: "Partly Cloudy",
     icon: "partly-cloudy-day",
     nearestStormDistance: 0,
     precipIntensity: 0,
     precipProbability: 0,
     temperature: 57.24,
     apparentTemperature: 57.24,
     dewPoint: 48.03,
     humidity: 0.71,
     windSpeed: 12.38,
     windBearing: 299,
     visibility: 9.6,
     cloudCover: 0.54,
     pressure: 1014.92,
     ozone: 396.97
     */
    
}
