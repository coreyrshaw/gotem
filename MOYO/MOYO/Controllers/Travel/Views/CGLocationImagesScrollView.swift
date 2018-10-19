//
//  CGLocationImagesScrollView.swift
//  CityGuide
//
//  Copyright © 2016 dmbTeam. All rights reserved.
//

import UIKit
import AlamofireImage

class CGLocationImagesScrollView: UIScrollView {

    var imagesList:NSArray = [String]() as NSArray
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func setUpImages(_ frame:CGRect) {
        
        var x = 0.0
        
        var placeholderImage:UIImage!
        
        if CGLocationsManager.sharedInstance.selectedLocationTypeIsSleep() {
            placeholderImage = UIImage(named: "sleep_placeholder")
        } else if CGLocationsManager.sharedInstance.selectedLocationTypeIsEat() {
            placeholderImage = UIImage(named: "eat_placeholder")
        } else if CGLocationsManager.sharedInstance.selectedLocationTypeIsEnjoy() {
            placeholderImage = UIImage(named: "enjoy_placeholder")
        } else if CGLocationsManager.sharedInstance.selectedLocationTypeIsFavorites() {
            placeholderImage = UIImage(named: "fav_placeholder")
        }
        
        if imagesList.count == 0 {
            let imageView:UIImageView = UIImageView(frame: CGRect(x: CGFloat(x), y: 0, width: frame.size.width, height: frame.size.height))
            imageView.contentMode = UIViewContentMode.scaleAspectFill
            imageView.image = placeholderImage
            
            self.addSubview(imageView)
            
            x += Double(frame.size.width)
        }
        
        for locationimage in imagesList {
            
            let imageView:UIImageView = UIImageView(frame: CGRect(x: CGFloat(x), y: 0, width: frame.size.width, height: frame.size.height))
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.isOpaque = true
            imageView.backgroundColor = UIColor.clear
            let bluredImage = UIImageView(frame: imageView.frame)
            let blurEffect = UIBlurEffect(style: .regular)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = bluredImage.bounds
            bluredImage.addSubview(blurEffectView)
            bluredImage.clipsToBounds = true
            blurEffectView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            if let downloadURL = URL(string:"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(locationimage)&key=\(Constants.placesApiKey)") {
                imageView.af_setImage(withURL: downloadURL, placeholderImage: placeholderImage)
                { (response) in
                    if let image = response.result.value {
                        bluredImage.image = image
                    }
                }
            }
            self.addSubview(bluredImage)
            self.addSubview(imageView)
            
            x += Double(frame.size.width)
        }
        
        self.contentSize = CGSize(width: CGFloat(x), height: frame.size.height)
    }
}
