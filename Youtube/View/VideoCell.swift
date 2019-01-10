//
//  VideoCell.swift
//  Youtube
//
//  Created by Dake Aga on 11/18/18.
//  Copyright © 2018 Dake Aga. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VideoCell: BaseCell{
    
    var video: Video? {
        didSet{
            
            fetchThumbnailImage()
            fetchProfileImage()
            
            guard let title = video?.title else {fatalError()}
            guard let numberOfViews = video?.numberOfViews  else {fatalError()}
            guard let channelName = video?.channel?.name else {fatalError()}
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            
            titleLabel.text = title
            subtitleTextView.text = "\(channelName) • \(numberFormatter.string(from: NSNumber(value: numberOfViews))!) • 2 years ago"

//          to make cell resizable according to text size
//          dont forget to change the number of lines of UILabel to 2
            let size = CGSize(width: frame.width - 16 - 44 - 8 - 16, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedRect = NSString(string: title).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)], context: nil)
            
            if estimatedRect.size.height > 20 {
                titleLabelHeightConstraint?.constant = 44
            } else {
                titleLabelHeightConstraint?.constant = 20
            }
        }
    }
    
    func fetchThumbnailImage(){
        guard let thumbnailImageUrl = video?.thumbnailImageName else {fatalError()}
        thumnailImageView.loadImageWithURLString(urlString: thumbnailImageUrl)
    }
    
    func fetchProfileImage(){
        guard let profileImageUrl = video?.channel?.profileImageName else {fatalError()}
        profileImageView.loadImageWithURLString(urlString: profileImageUrl)
    }
    
    let thumnailImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = UIImage(named: "taylor_swift_blank_space")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = UIImage(named: "taylor_swift_profile")
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let separatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        return separator
    }()
    
    let titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Taylor Swift - Blank Space"
        title.numberOfLines = 2
        return title
    }()
    
    let subtitleTextView: UITextView = {
        let subtitle = UITextView()
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.text = "TaylorSwiftVEVO - 1,604,684,607 - 2 years ago"
        subtitle.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        subtitle.textColor = UIColor.lightGray
        return subtitle
    }()
    
    var titleLabelHeightConstraint: NSLayoutConstraint?
    
    override func setupViews(){
        addSubview(thumnailImageView)
        addSubview(separatorView)
        addSubview(profileImageView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)
        
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: thumnailImageView)
        addConstraintsWithFormat(format: "H:|-16-[v0(44)]|", views: profileImageView)
        addConstraintsWithFormat(format: "V:|-16-[v0]-8-[v1(44)]-16-[v2(1)]|", views: thumnailImageView,profileImageView,separatorView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: separatorView)
        
        // To enable dynamic autoresize
        addConstraint(NSLayoutConstraint.init(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: thumnailImageView, attribute: .bottom, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint.init(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: profileImageView, attribute: .right, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint.init(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: thumnailImageView, attribute: .right, multiplier: 1, constant: 0))
//      to make titleLabel height auto resizable
        titleLabelHeightConstraint = NSLayoutConstraint.init(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 20)
        addConstraint(titleLabelHeightConstraint!)
        
        addConstraint(NSLayoutConstraint.init(item: subtitleTextView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 4))
        addConstraint(NSLayoutConstraint.init(item: subtitleTextView, attribute: .left, relatedBy: .equal, toItem: profileImageView, attribute: .right, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint.init(item: subtitleTextView, attribute: .right, relatedBy: .equal, toItem: thumnailImageView, attribute: .right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint.init(item: subtitleTextView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30))
    }
}



