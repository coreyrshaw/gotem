//
//  API.swift
//  MOYO
//
//  Created by Corey S on 25/08/2018.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import Foundation
import Alamofire

enum APIError: Error {
    case anyError
}

enum ApiResult<T>{
    case Success(result:T)
    case Error(message:String)
}
let kUnknownError = NSLocalizedString("Unknown error", comment: "Unknown error")
class API {
    public static let `default` = API()
    typealias APIBoolResult = ApiResult<Bool>
    func login(user: Int, password: String, completion: @escaping (APIBoolResult) -> Void){
        let request = Alamofire.request(Router.login(userId: user, password: password))
        .validate()
        .responseJSON { (response) in
            if let error = response.error {
                completion(APIBoolResult.Error(message: error.localizedDescription))
                return
            }
            if let json = response.result.value as? [String: Any], let token = json ["token"] as? String {
                DataHolder.token = token
                DataHolder.userID = user
            }
            else {
                completion(APIBoolResult.Error(message: "Unknown error:"))
            }
            completion(API.APIBoolResult.Success(result: true))
        }
        print(request.debugDescription)
    }
    func sendDataReq(fileURL : URL, taskFolder : String = "moyoiostestdata", completion: @escaping (APIBoolResult) -> Void) {
        let uploadURL = (try! Router.uploadFile().asURLRequest().url)!
        let token = DataHolder.token!
        let timestamp = String(Int(round(NSDate().timeIntervalSinceReferenceDate * 1000)))
        print(timestamp)
        
        let headers = [
            "Authorization": "Mars \(String(token))",
            "weekMillis": timestamp,
            "Content-Type": "multipart/form-data",
                        ] as [String : Any]
        print("here is the token")
        print("\(String(describing: token))")
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append("\(taskFolder)".data(using: .utf8)!, withName: "folder")
            multipartFormData.append(fileURL, withName: "upload")
        },
                         to: uploadURL,
                         headers: headers as? HTTPHeaders, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in debugPrint(response)
                    
                    // parse response
                    // if response == "file uploaded", then delete the file
                    // else...
                    
                    let jsonDictionary = response.value as? [String: Any]
                    print("here is the jsonDictionary")
                    print(jsonDictionary ?? "default")
                    if let message = jsonDictionary?["file"] as? String {
                        if message == "file uploaded" {
                            print("upload successful")
                        } else {
                            print("upload unsuccessful")
                        }
                    }
                    }
                    completion(API.APIBoolResult.Success(result: true))
                    
                case .failure(let encodingError): print(encodingError)
                    completion(API.APIBoolResult.Error(message: encodingError.localizedDescription))
                }
        })
        
    }
    func uploadFile(millis:Int64, data:Data, fileName:String, taskFolder:String = "moyoiostestdata", completion: @escaping (APIBoolResult) -> Void){
        let url = try! Router.uploadFile().asURLRequest().url
        var mimeType = "application/octet-stream"
        switch url!.lastPathComponent {
        case "jpg", "jpeg":
            mimeType = "image/jpeg"
        case "png":
            mimeType = "image/png"
        case "csv":
            mimeType = "text/csv"
        default:
            break
        }

        if url?.pathExtension == "jpg" {
            mimeType = "image/jpeg"
        }
        Alamofire.upload(multipartFormData: { (MultipartFormData) in
            MultipartFormData.append("\(taskFolder)".data(using: .utf8)!, withName: "folder")
            MultipartFormData.append(data, withName: "upload", fileName: fileName, mimeType: mimeType)
        }, to:url!,
           headers: ["Authorization" : "Mars " + DataHolder.token!,
                    //"Accept" : "application/json",
                    "weekMillis" : "\(millis)"])
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload
                    .responseJSON { response in
                        if let error = response.error {
                            completion(APIBoolResult.Error(message: error.localizedDescription))
                            return
                        }
                        else if let json = response.value as? [String: Any]{
                            if let message = json["success"] as? String {
                                if message == "you have completed upload to amoss_mhealth" {
                                    print("upload successful")
                                    completion(API.APIBoolResult.Success(result: true))
                                    return
                                } else {
                                    print("upload unsuccessful")
                                }
                            }
                        }
                        completion(API.APIBoolResult.Success(result: false))
                }
            case .failure(let encodingError):
                #if DEBUG
                print(encodingError)
                #endif
                completion(API.APIBoolResult.Error(message: encodingError.localizedDescription))
            }
        }
    }
}
