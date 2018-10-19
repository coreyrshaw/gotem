//
//  NetworkManager.swift
//  MOYO
//
//  Created by Whitney H on 8/15/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    var manager : SessionManager?
    var token = "TOKENLI"
    
    init() {
        
        let serverTrustPolicy : [String : ServerTrustPolicy]   = [
            "" : ServerTrustPolicy.disableEvaluation        ]
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        
        manager = Alamofire.SessionManager(configuration : configuration, serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicy))

        manager?.delegate.sessionDidReceiveChallenge = { session, challenge in
     
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                return (URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
            }
            return (URLSession.AuthChallengeDisposition.performDefaultHandling, Optional.none)
        }
    }
    
}
