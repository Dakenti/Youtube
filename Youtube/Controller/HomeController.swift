//
//  ViewController.swift
//  Youtube
//
//  Created by Dake Aga on 11/10/18.
//  Copyright © 2018 Dake Aga. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var videos: [Video]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchVideos()
        
//        navigationItem.title = "Home"
        
        navigationController?.navigationBar.isTranslucent = false
        
        collectionView.backgroundColor = UIColor.white
        
        let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 48, height: view.frame.height))
        textLabel.text = "Home"
        textLabel.textColor = UIColor.white
        textLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = textLabel
        
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: "CellID")
        
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        setupMenuBar()
        
        setupNavBarButtons()
    }
    
    func fetchVideos(){
        let url = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
            
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    
                    self.videos = [Video]()
                    
                    for dictionary in json as! [[String: AnyObject]] {
                        
                        let video = Video()
                        video.title = dictionary["title"] as? String
                        video.thumbnalImage = dictionary["thumbnail_image_name"] as? String
                        video.numberOfViews = dictionary["number_of_views"] as? NSNumber
                        
                        let channelDictionary = dictionary["channel"] as! [String: AnyObject]
                        
                        let channel = Channel()
                        channel.name = channelDictionary["name"] as? String
                        channel.profileIamge = channelDictionary["profile_image_name"] as? String
                        
                        video.channel = channel
                        
                        self.videos?.append(video)
                    }
                    
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                    
                } catch let jsonError {
                    print(jsonError)
                }
            
            }.resume()
    }
    
    private func setupNavBarButtons(){
        let searchImage = UIImage(named: "search_icon")?.withRenderingMode(.alwaysOriginal)
        let moreImage = UIImage(named: "nav_more_icon")?.withRenderingMode(.alwaysOriginal)
        
        let searchButton = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearchBarButton))
        let moreButton = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(handleMoreBarButton))
        
        navigationItem.rightBarButtonItems = [moreButton, searchButton]
    }
    
    @objc func handleSearchBarButton(){
        
    }
    
    let settingsLauncher = SettingsLauncher()
    @objc func handleMoreBarButton(){
        settingsLauncher.showSettings()
    }
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    func setupMenuBar(){
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:|[v0(50)]", views: menuBar)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath) as! VideoCell
        
        cell.video = videos?[indexPath.item]

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.width - 16 - 16) * 9 / 16
        return CGSize(width: view.frame.width, height: height + 16 + 68)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}













