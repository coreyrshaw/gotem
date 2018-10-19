//
//  Constants.swift
//
//  Created by Corey S on 31/07/18.
//  Copyright © 2018 Moyo. All rights reserved.
//

import UIKit

class MapMarkerInfoWindow: UIView {
    
    var label : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "dummy_user")
        return imageView
    }()
    
    var emailLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.text = "sp@gmail.com"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMarkerView()
        self.addSubview(label)
        self.addSubview(imageView)
        self.addSubview(emailLabel)
        label.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        updateViewComponents()
        
    }
    
    func updateViewComponents(){
        
        //x,y,height,width imageView
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        //x,y,height, width Label
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        label.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: 5).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        
        emailLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5).isActive = true
        emailLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5).isActive = true
        emailLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        
    }
    
    func setupMarkerView(){
        layer.cornerRadius = 10.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
        layer.masksToBounds = true
        backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
