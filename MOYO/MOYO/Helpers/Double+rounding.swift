//
//  Double+Rounding.swift
//  MOYO
//
//  Created by Corey S on 7/31/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import Foundation
import UIKit

extension Double {
    enum PastDecimal : Double {
        case tenths = 0.10
        case hundredths = 0.01
    }
    mutating func rnd(toNearest place: PastDecimal) -> Double {
        return Darwin.round(self / place.rawValue) * place.rawValue
    }
}
