//
//  StaticFunc.swift
//  MOYO
//
//  Created by Corey S on 16/09/2018.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import Foundation
import KRProgressHUD

func formattedDateAndMillis() -> (String, Int64) {
    let date = Date()
    let millis = Int64(date.timeIntervalSinceReferenceDate * 1000)
    let formmatter = DateFormatter()
    formmatter.dateFormat = "yyyyMMdd-hh:mm"
    let formattedDate = formmatter.string(from: date)
    return (formattedDate, millis)
}


func sendFile(fileName name: String, withString string: String, completion: ((_ success: Bool) -> Void)? = nil) {
    let (formattedDate, millis) = formattedDateAndMillis()
    // send presure
    if let user = DataHolder.userID {
        let fileName = "\(formattedDate)/\(millis)/\(user)+\(name).csv"
        // send data
        let data = string.data(using: .utf8)!
        KRProgressHUD.show(withMessage:NSLocalizedString("Sending data..", comment: ""), completion: nil)
        print("file:\n" + fileName)
        print("data:\n" + string)
        API.default.uploadFile(millis: millis, data: data, fileName:fileName, completion: { (result) in
            KRProgressHUD.dismiss()
            switch result {
            case let .Error(message):
                UIViewController.showError(message: message)
                completion?(false)
            case .Success:
                completion?(true)
            }
        })
    }
    else {
        completion?(false)
    }
}
