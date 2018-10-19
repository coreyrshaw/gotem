//
//  CGLocationPriceRatingView.swift
//  CityGuide
//
//  Copyright © 2016 dmbTeam. All rights reserved.
//

import UIKit

class CGLocationPriceRatingView: UIView {

    var priceRating:Double!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        var x = 0.0
        
        if priceRating != nil {
            
            for i in 0...4 {
                let unitView:UIView = UIView(frame: CGRect(x: CGFloat(x), y: 0, width: 21, height: 21))
                unitView.backgroundColor = UIColor.lightGray
                unitView.layer.cornerRadius = 8.0
                unitView.clipsToBounds = true
                self.addSubview(unitView)
                
                if i < Int(self.priceRating) {
                    
                    unitView.backgroundColor = CGColors().colorForCurrentLocationType()
                    
                } else if Double(i) < self.priceRating as Double {
                    
                    let decimal:Float = Float(priceRating.truncatingRemainder(dividingBy: 1))
                    if decimal > 0 {
                        let partView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(21 * decimal), height: 21))
                        partView.backgroundColor = CGColors().colorForCurrentLocationType()
                        unitView.addSubview(partView)
                    }
                }
                
                x += 31
            }
        }
        
        if priceRating == nil {
            let label = UILabel(frame: CGRect(x: CGFloat(x), y: 0, width: 30, height: 21))
            label.text = "-/-"
            self.addSubview(label)
        }
    }
}
