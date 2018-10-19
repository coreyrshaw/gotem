//
//  CGLocationReviewTableViewCell.swift
//  CityGuide
//
//  Copyright © 2016 dmbTeam. All rights reserved.
//

import UIKit

class CGLocationReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var autorImageView: UIImageView!
    @IBOutlet weak var autorNameLabel: UILabel!
    @IBOutlet weak var locationRatingView: CGLocationRatingView!
    @IBOutlet weak var reviewDateLabel: UILabel!
    @IBOutlet weak var reviewTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
