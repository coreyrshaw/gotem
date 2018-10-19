//
//  Pollution.swift
//  MOYO
//
//  Created by Corey.S on 7/31/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import Foundation

struct CurrentPollution
{
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    struct PollutionCategory {
        let Number: Int
        let Name: String
    }
    let DateIssue: Date
    let DateForecast: Date
    let ReportingArea: String
    let StateCode: String
    let Latitude: Double
    let Longitude: Double
    let ParameterName: String
    let AQI: Int
    let Category: PollutionCategory
    let ActionDay: Bool
    let Discussion: String
    // [{"DateIssue":"2018-08-25 ","DateForecast":"2018-08-26 ","ReportingArea":"Yuba City/Marysville","StateCode":"CA","Latitude":39.1389,"Longitude":-121.6175,"ParameterName":"O3","AQI":51,"Category":{"Number":2,"Name":"Moderate"},"ActionDay":false,"Discussion":""}]
    enum PK: String {
        case DateIssue
        case DateForecast
        case ReportingArea
        case StateCode
        case Latitude
        case Longitude
        case ParameterName
        case AQI
        case Category
        case ActionDay
        case Discussion
    }
    enum CK: String {
        case Number
        case Name
    }
    init(pollutionDictionary: [String : Any]) throws
    {
        DateIssue = CurrentPollution.dateFormatter.date(from: pollutionDictionary[PK.DateIssue.rawValue, default: "2000-01-01"] as! String)!
        DateForecast = CurrentPollution.dateFormatter.date(from: pollutionDictionary[PK.DateForecast.rawValue, default: "2000-01-01"] as! String)!
        ReportingArea = pollutionDictionary[PK.ReportingArea.rawValue] as! String
        StateCode = pollutionDictionary[PK.StateCode.rawValue] as! String
        Latitude = pollutionDictionary[PK.Latitude.rawValue] as! Double
        Longitude = pollutionDictionary[PK.Longitude.rawValue] as! Double
        ParameterName = pollutionDictionary[PK.Longitude.rawValue] as! String
        AQI = pollutionDictionary[PK.AQI.rawValue] as! Int
        let cat = pollutionDictionary[PK.Category.rawValue] as! [String: Any]
        Category = PollutionCategory(Number: cat[CK.Number.rawValue] as! Int, Name: cat[CK.Name.rawValue] as! String)
        ActionDay = pollutionDictionary[PK.Longitude.rawValue] as! Bool
        Discussion = pollutionDictionary[PK.Longitude.rawValue] as! String
    }
    

}
