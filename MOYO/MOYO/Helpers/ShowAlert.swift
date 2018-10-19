//
//  ShowAlert.swift
//  BookingApp
//
//  Created by Corey S on 6/7/17.
//  Copyright © 2017 BookingApp. All rights reserved.
//


import UIKit

extension UIViewController{
    func showError(message:String){
        self.showAlert(title: NSLocalizedString("Error", comment: "error"),
                       message: message)
    }
    func showAlert(title:String?, message:String?, completion: ((UIAlertAction) -> Void)? = nil)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alerAction = UIAlertAction(title: "OK", style: .default, handler: completion)
        
        alert.addAction(alerAction)
        self.present(alert, animated: true, completion: nil)
    }
    func askQuestion(title:String?, message:String?, completion: @escaping (_ success:Bool) -> Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { action in
            completion(true)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { action in 
            completion(true)
        })
        
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    static func showError(message:String){
        self.showAlert(title: NSLocalizedString("Error", comment: "error"),
                       message: message)
    }
    static func showAlert(title:String?, message:String?, completion: ((UIAlertAction) -> Void)? = nil)  {
        if let vc = UIApplication.shared.keyWindow?.rootViewController{
            vc.showAlert(title: title, message: message, completion: completion)
        }
    }
}

