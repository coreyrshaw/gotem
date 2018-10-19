//
//  CGAboutImageCollectionViewCell.swift
//  CityGuide
//
//  Copyright © 2016 dmbTeam. All rights reserved.
//

import UIKit

class CGAboutImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? AboutVCLayoutAttributes {
            imageViewHeightConstraint.constant = attributes.photoHeight
        }
    }
}
