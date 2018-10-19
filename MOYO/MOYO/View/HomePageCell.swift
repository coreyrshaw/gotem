//
//  HomePageCell.swift
//  MOYO
//
//  Created by Corey S on 7/30/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import UIKit

class HomePageCell: UITableViewCell {
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var menuTitle: UILabel!
    @IBOutlet weak var menuContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
