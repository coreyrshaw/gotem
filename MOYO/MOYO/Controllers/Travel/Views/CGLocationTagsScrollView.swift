//
//  CGLocationTagsScrollView.swift
//  CityGuide
//
//  Copyright © 2016 dmbTeam. All rights reserved.
//

import UIKit

class CGLocationTagsScrollView: UIScrollView {

    var tagsList:NSArray = [String]() as NSArray
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func setUpTags() {
        var x = 0.0
        
        for tag in tagsList {
            
            let label = UILabel(frame: CGRect(x: 5, y: 0, width: 30, height: 21))
            label.text = tag as? String
            label.textColor = CGColors().colorForCurrentLocationType()
            label.sizeToFit()
            
            let tagView:UIView = UIView(frame: CGRect(x: CGFloat(x), y: 0, width: label.frame.size.width + 10, height: 21))
            tagView.addSubview(label)
            tagView.layer.cornerRadius = 8.0
            tagView.clipsToBounds = true
            tagView.layer.borderColor = CGColors().colorForCurrentLocationType().cgColor
            tagView.layer.borderWidth = 0.5
            self.addSubview(tagView)
            
            x += Double(label.frame.size.width + 20)
        }
        
        self.contentSize = CGSize(width: CGFloat(x + 10), height: 21)
    }
}
