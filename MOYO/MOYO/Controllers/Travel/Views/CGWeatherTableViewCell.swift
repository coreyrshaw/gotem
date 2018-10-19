//
//  CGWeatherTableViewCell.swift
//  CityGuide
//
//  Copyright © 2016 dmbTeam. All rights reserved.
//

import UIKit

class CGWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var forecastLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var forecastDateLabel: UILabel!
    @IBOutlet weak var forecastImageView: UIImageView!
    @IBOutlet weak var forecastValueLabel: UILabel!
    @IBOutlet weak var forecastTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }
}
