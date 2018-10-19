//
//  Common Button.swift
//  MOYO
//
//  Created by Corey S on 8/23/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import UIKit

class LegalCommonButton: UIButton {
    
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                alpha = 1.0
            } else {
                alpha = 0.5
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    func commonInit() {
        backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        clipsToBounds = true
        layer.cornerRadius = 8
        setTitleColor(UIColor.white, for: .normal)
        setTitleColor(UIColor.lightGray, for: .disabled)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

