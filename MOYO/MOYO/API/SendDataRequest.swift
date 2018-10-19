//
//  SendDataRequest.swift
//  MOYO
//
//  Created by Whitney H on 8/15/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import Foundation
import Alamofire

struct sendDataRequest {
    func sendDataReq(fileURL : URL, taskFolder : String) {
        var manager : SessionManager?
        let uploadManager = NetworkManager()
        
        //REPLACE TOKENLI WITH ACTUAL TOKEN FROM LOGIN
        let headers = [ "Authorization": "Bearer \("tokenLI")",
            "Content-Type":"multipart/form-data; charset=utf-8; boundary=__X_PAW_BOUNDARY__",
            ]
        print("here is the token")
        
        print("\("tokenLI")")
        
        
        uploadManager.manager?.upload(multipartFormData: { multipartFormData in multipartFormData.append("\(taskFolder)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "folder")
            multipartFormData.append(fileURL, withName: "upload")}, to: "https://amoss.emory.edu/uploadFiles", headers: headers, encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _): upload.responseJSON { response in debugPrint(response)
                    
                    
                    // parse response
                    // if response == "file uploaded", then delete the file
                    // else...
                    
                    let jsonDictionary = parseJSON(data: response.data)
                    print("here is the jsonDictionary")
                    print(jsonDictionary ?? "default")
                    if let message = jsonDictionary?["msg"] as? String {
                        if message == "file uploaded" {
                            print("upload successful")
                            
                            // delete csv
                            do {
                                try FileManager().removeItem(at: fileURL)
                            } catch {
                                print("Could not remove CSV file")
                            }
                            
                        } else {
                            print("upload unsuccessful")
                        }
                    }
                    }
                    
                case .failure(let encodingError): print(encodingError)
                }
        })
        
        // Convert Data to JSON
        func parseJSON(data : Data?) -> [String : AnyObject]? {
            var theDictionary : [String : AnyObject]? = nil
            
            if let data = data {
                do {
                    if let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject] {
                        theDictionary = jsonDictionary
                    } else {
                        print(" I couldn't parse jsonDictionary")
                    }
                } catch {
                    
                }
            } else {
                print("Could not unwrap data")
            }
            return theDictionary
        }
    }
}

