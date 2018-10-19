//
//  Constants.swift
//
//  Created by Corey S on 31/07/18.
//  Copyright © 2018 Moyo. All rights reserved.
//

import Foundation
import Alamofire

class PollutionService
{
    // Sample url:http://www.airnowapi.org/aq/forecast/latLong/?format=text/csv&latitude=39.0509&longitude=-121.4453&date=2018-07-31&distance=25&API_KEY=73637498-BE6A-46B0-9322-A1F1F987FB80
    
    class BaseUrl: URLConvertible {
        internal(set) var url: URL
        init(url _url: URL) {
            url = _url
        }
        func asURL() throws -> URL {
            return url
        }
    }
    let pollutionAPIKey: String
    let pollutionBaseURL: URL?
    class url: URLConvertible {
        internal(set) var url: URL
        init(url _url: URL) {
            url = _url
        }
        func asURL() throws -> URL {
            return url
        }
    }
    init(APIKey: String)
    {
        self.pollutionAPIKey = APIKey
        pollutionBaseURL = URL(string: "http://www.airnowapi.org/aq/forecast/latLong/")
        
    }
    // sample
    // http://www.airnowapi.org/aq/forecast/latLong/?format=text/application/json&latitude=39.0509&longitude=-121.4453&date=2018-08-26&distance=25&API_KEY=27624D17-ABBB-4FFE-BF82-C84B27D6A621
    func getCurrentPollution(latitude: Double, longitude: Double, completion: @escaping (CurrentPollution?) -> Void)
    {
        let pollutionURL = BaseUrl(url: pollutionBaseURL!)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let req = Alamofire.request(pollutionURL,
                          method: .get,
                          parameters: [
                            "API_KEY" : pollutionAPIKey,
                            "format" : "application/json",
                            "latitude": latitude,
                            "longitude":longitude,
                            "distance": 1,
                            "date": formatter.string(from: Date())
                            ],
                          encoding: URLEncoding.default,
                          headers: nil)
            .responseJSON(completionHandler: { (response) in
                if let jsonDictionary = response.result.value as? [String : Any] {
                    if let currentPollution = try? CurrentPollution(pollutionDictionary: jsonDictionary) {
                        completion(currentPollution)
                    } else {
                        completion(nil)
                    }
                }
                else {
                    completion(nil)
                }
            })
        print(req)
    }
}
