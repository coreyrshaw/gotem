//
//  CGLocationsTableViewCell.swift
//  CityGuide
//
//  Copyright © 2016 dmbTeam. All rights reserved.
//

import UIKit
import SnapKit

class CGLocationsTableViewCell: UITableViewCell {

    @IBOutlet weak var bluredLocationImageView: UIImageView!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationTitlelabel: UILabel!
    @IBOutlet weak var priceLevelLabel: UILabel!
    @IBOutlet weak var ratingLevelLabel: UILabel!
    
    @IBOutlet weak var priceRatingView: CGLocationPriceRatingView!
    @IBOutlet weak var locationRatingView: CGLocationRatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        priceLevelLabel.text = NSLocalizedString("PriceRatingKey", comment: "Price Rating Label")
        ratingLevelLabel.text = NSLocalizedString("RatingKey", comment: "Rating Label")
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bluredLocationImageView.bounds
        bluredLocationImageView.addSubview(blurEffectView)
        blurEffectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
