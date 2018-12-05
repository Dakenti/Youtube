//
//  SettingsCell.swift
//  Youtube
//
//  Created by Dake Aga on 12/5/18.
//  Copyright © 2018 Dake Aga. All rights reserved.
//

import UIKit

class SettingsCell: BaseCell{
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "settings"
        return label
    }()
    
    let iconImageView: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "settings")
        icon.contentMode = .scaleAspectFill
        return icon
    }()
    
//    override func setupViews() {
//        super.setupViews()
//        
//        addSubview(nameLabel)
//        addSubview(iconImageView)
//        
//        addConstraintsWithFormat(format: "H:|-8-[v0(30)]-8-[v1]|", views: iconImageView, nameLabel)
//        addConstraintsWithFormat(format: "V:|[v0]|", views: nameLabel)
//        addConstraintsWithFormat(format: "V:|[v0(30)]|", views: iconImageView)
//        
//        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
//    }
    override func setupViews() {
        super.setupViews()
        
        addSubview(nameLabel)
        addSubview(iconImageView)
        
        addConstraintsWithFormat(format: "H:|-8-[v0(30)]-8-[v1]|", views: iconImageView, nameLabel)
        
        addConstraintsWithFormat(format: "V:|[v0]|", views: nameLabel)
        
        addConstraintsWithFormat(format: "V:[v0(30)]", views: iconImageView)
        
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
    }
}
