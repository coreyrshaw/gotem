//
//  DataUploadToAWS.swift
//  MOYO
//
//  Created by Corey S on 8/10/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


//let uploadManager = NetworkManager()
//class DataUploadToAWS : NSObject {
//
//
//
//
//    func sendDataReq(fileURL : URL, tokenLI : String, taskFolder : String) {
//
//        let headers = [ "Authorization": "Bearer \(tokenLI)",
//            "Content-Type":"multipart/form-data; charset=utf-8; boundary=__X_PAW_BOUNDARY__",
//            ]
//        print("here is the token")
//
//        print("\(tokenLI)")
//
//
//        uploadManager.manager?.upload(multipartFormData: { multipartFormData in multipartFormData.append("\(taskFolder)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "folder")
//            multipartFormData.append(fileURL, withName: "upload")}, to: API_URL + kUPLOADSENDPOINT, headers: headers, encodingCompletion: { encodingResult in
//
//                switch encodingResult {
//                case .success(let upload, _,_ ): upload.responseJSON { response in debugPrint(response)
//
//
//                    // parse response
//                    // if response == "file uploaded", then delete the file
//                    // else...
//
//                    let jsonDictionary = self.parseJSON(data: response.data)
//                    print("here is the jsonDictionary")
//                    print(jsonDictionary ?? "default")
//
//                    if let message = jsonDictionary?["msg"] as? String {
//                        if message == "file uploaded" {
//                            print("upload successful")
//
//                            // delete csv
//                            do {
//                                try FileManager().removeItem(at: fileURL)
//                            } catch {
//                                print("Could not remove CSV file")
//                            }
//
//                        } else {
//                            print("upload unsuccessful")
//                        }
//                    }
//                    }
//
//                case .failure(let encodingError): print(encodingError)
//                }
//        })
//    }
//
//}
