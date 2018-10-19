//
//  MoodPageCell.swift
//  MOYO
//
//  Created by Corey S on 8/29/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import UIKit

class MoodCell: UITableViewCell {
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var menuTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
