//
//  SettingsCell.swift
//  Youtube
//
//  Created by Dake Aga on 12/5/18.
//  Copyright © 2018 Dake Aga. All rights reserved.
//

import UIKit

class SettingsCell: BaseCell{
        
    override var isHighlighted: Bool{
        didSet{
            backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.white
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            iconImageView.tintColor = isHighlighted ? UIColor.white : UIColor.darkGray
        }
    }
    
    var setting: Settings? {
        didSet{
            guard let imageName = setting?.imageName else {fatalError()}
            
            nameLabel.text = setting?.name.rawValue
            iconImageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
            iconImageView.tintColor = UIColor.darkGray
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "settings"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let iconImageView: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "settings")
        icon.contentMode = .scaleAspectFill
        return icon
    }()
    
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
