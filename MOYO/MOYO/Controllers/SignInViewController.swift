//
//  SignInViewController.swift
//  MOYO
//
//  Created by Corey S on 8/23/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import UIKit
import KRProgressHUD
// import MBProgressHUD

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var signinButton: LegalCommonButton!
    
    var fbProfile: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
//        let singleFingerTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
//        view.addGestureRecognizer(singleFingerTap)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signInBtn_Click(_ sender: Any) {
        
        errorLabel.text = ""
        view.endEditing(true)
        
        guard let email = emailText.text, email.count > 0 else {
            errorLabel.text = NSLocalizedString("Please input participation id.", comment: "")
            return
        }
        guard let userID = Int(email) else {
            errorLabel.text = NSLocalizedString("Please input only digits for participation id.", comment: "")
            return
        }
        
        guard let password = passwordText.text, password.count >= 3 else {
            errorLabel.text = NSLocalizedString("Please input password.", comment: "")
            return
        }
        KRProgressHUD.show(withMessage:  NSLocalizedString("Authorizing", comment: ""), completion: nil)
        API.default.login(user: userID, password: password) { (result) in
            KRProgressHUD.dismiss()
            switch result {
            case let .Error(message):
                self.showError(message: message)
            case .Success:
                AppDelegate.appDelegate?.scheduleBloodNotification()
                AppDelegate.appDelegate?.scheduleFoodNotification()
                self.performSegue(withIdentifier: "showHome", sender: nil)
            }
        }
        
        
//        @IBAction func contactUsButton(_ sender: UIButton) {
//            let contactUsVC = storyboard?.instantiateViewController(withIdentifier: "contactUsVC") as! ContactUsViewController
//            self.present(contactUsVC, animated: false, completion: nil)
//
//        }
//        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.label.text = NSLocalizedString("SignIn", comment: "")
//        hud.detailsLabel.text = NSLocalizedString("Please wait", comment: "")
//        hud.isUserInteractionEnabled = false
        
//        Perform sign in function

    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    }
}

