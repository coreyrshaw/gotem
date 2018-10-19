//
//  ContactUsViewController.swift
//  MOYO
//
//  Created by Corey S on 9/19/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {

    let contactUsURL = "https://moyohealth.net/contact.html"
    @IBOutlet weak var contactUsWebView: UIWebView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        let requestURL = URL(string:contactUsURL)
        let request = URLRequest(url: requestURL!)
        contactUsWebView.loadRequest(request)
        
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
