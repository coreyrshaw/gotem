//
//  UIViewControlerExtensions.swift
//  MOYO
//
//  Created by Corey S on 09/09/2018.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import UIKit

extension UIViewController {
    func topOffset () -> CGFloat {
        guard let nvbarh = self.navigationController?.navigationBar.frame.height else {
            return UIApplication.shared.statusBarFrame.height
        }
        return nvbarh + UIApplication.shared.statusBarFrame.height
    }
}

