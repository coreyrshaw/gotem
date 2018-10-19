//
//  Router.swift
//  MOYO
//
//  Created by Corey S on 23/08/2018.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import Foundation
import Alamofire
import KeychainSwift

class DataHolder {
    private static var _token: String? = nil
    private static let keychain = KeychainSwift()
    private static let apiToken = "api.token"
    private static let userName = "userIf"
    private static var _userID: Int? = nil
    static var userID: Int? {
        get {
            if let v = _userID  {
                return v
            }
            _userID = UserDefaults.standard.value(forKey: userName) as? Int
            return _userID
        }
        set {
            _userID = newValue
            UserDefaults.standard.set(_userID, forKey: userName)
            UserDefaults.standard.synchronize()
        }
    }
    static var token: String? {
        get {
            if let t = _token {
                return t
            }
            _token = keychain.get(apiToken)
            return _token
        }
        set {
            _token = newValue
            if let value = _token {
                keychain.set(value, forKey: apiToken)
            }
            else {
                keychain.delete(apiToken)
            }
        }
    }
}

enum Router: URLRequestConvertible {
    static let baseURL = "https://amoss.emory.edu"
    case login(userId: Int, password: String)
    case uploadFile()
    func methodAndPath() -> (HTTPMethod, String) {
        switch self {
        case .login:
            return (.post, "/loginParticipant")
        case .uploadFile:
            return (.post, "/upload")//Files")
        }
    }
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: Router.baseURL)
        let (method, path) = self.methodAndPath()
        var request = URLRequest(url: url!.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        // auth
        switch self {
        case .login:
            break
        case .uploadFile:
            if let token = DataHolder.token{
                request.setValue("Mars \(token)", forHTTPHeaderField: "authorization")
            }
        }
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        switch self {
        case let .login(userId, password):
            request = try JSONEncoding.default.encode(request, with:["participantID" : userId, "password": password])
        case .uploadFile:
            request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
            break
        }
        return request
    }
    
}
