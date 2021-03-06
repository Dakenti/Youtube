//
//  MenuBar.swift
//  Youtube
//
//  Created by Dake Aga on 11/24/18.
//  Copyright © 2018 Dake Aga. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    let cellId = "CellID"
    let imageNames = ["home", "trending", "subscriptions", "account"]
    
    var homeController: HomeController?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 31)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .centeredHorizontally)
        
        setupHorizontalSliddingWhiteBar()
    }
    
    var leftAnchorOfHorizontalBar: NSLayoutConstraint?
    
    func setupHorizontalSliddingWhiteBar(){
        let horizontalBar = UIView()
        horizontalBar.backgroundColor = UIColor(white: 0.95, alpha: 1)
        horizontalBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBar)
        
        leftAnchorOfHorizontalBar = horizontalBar.leftAnchor.constraint(equalTo: self.leftAnchor)
        leftAnchorOfHorizontalBar?.isActive = true
        
        horizontalBar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBar.heightAnchor.constraint(equalToConstant: 4).isActive = true
        horizontalBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/4).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let x = CGFloat(indexPath.item) * frame.width / 4
        
//        to change dispotion of the horizontal bar
//        leftAnchorOfHorizontalBar?.constant = x
//
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            self.layoutIfNeeded()
//        }, completion: nil)
        homeController?.changeHorizantalBarPostionByPressingMenuBarItem(menuIndex: indexPath.item)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.imageView.image = UIImage(named: imageNames[indexPath.row])?.withRenderingMode(.alwaysTemplate)
        cell.tintColor = UIColor.rgb(red: 91, green: 14, blue: 13)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 4, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

class MenuCell: BaseCell{
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "home")
        return iv
    }()
    
    override var isSelected: Bool {
        didSet{
            imageView.tintColor = isSelected ? UIColor.white : UIColor.rgb(red: 91, green: 14, blue: 13)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        addSubview(imageView)
        addConstraintsWithFormat(format: "H:[v0(28)]", views: imageView)
        addConstraintsWithFormat(format: "V:[v0(28)]", views: imageView)
        addConstraint(NSLayoutConstraint.init(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint.init(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}








