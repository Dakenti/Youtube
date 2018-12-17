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
    
    let titles = ["Home", "Trending", "Subscribtion", "Profile"]
    
    let cellId = "CellID"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchVideos()
        
        navigationBarSetup()
        
        collectioViewSetup()
        
        setupMenuBar()
        
        setupNavBarButtons()
    }
    
    func fetchVideos(){
        API.sharedInstance.fetchVideos { (videos: [Video]) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
    
    func navigationBarSetup(){
        navigationController?.navigationBar.isTranslucent = false
        let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 48, height: view.frame.height))
        textLabel.text = "  Home"
        textLabel.textColor = UIColor.white
        textLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = textLabel
    }
    
    func collectioViewSetup(){
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        collectionView.isPagingEnabled = true
        
        collectionView.backgroundColor = UIColor.white
        
//      collectionView.register(VideoCell.self, forCellWithReuseIdentifier: "CellId")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
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
    
    lazy var settingsLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.homeController = self
        return launcher
    }()
    
    @objc func handleMoreBarButton(){
        settingsLauncher.showSettings()
    }
    
    func showSlideOutMenuOptionsPage(setting: Settings){
        let dummyUIView = UIViewController()
        dummyUIView.navigationItem.title = setting.name.rawValue
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        dummyUIView.view.backgroundColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.pushViewController(dummyUIView, animated: true)
    }
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    func changeHorizantalBarPostionByPressingMenuBarItem(menuIndex: Int){
        let index = IndexPath(item: menuIndex, section: 0)
        collectionView.selectItem(at: index, animated: true, scrollPosition: .centeredHorizontally)
        
        setTitle(index: menuIndex)
    }
    
    func setupMenuBar(){
        navigationController?.hidesBarsOnSwipe = true
        let redView = UIView()
        redView.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 31)
        
        view.addSubview(redView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: redView)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: redView)
        
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: menuBar)
        
        menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.leftAnchorOfHorizontalBar?.constant = scrollView.contentOffset.x / CGFloat(menuBar.collectionView.numberOfItems(inSection: 0))
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        
        setTitle(index: Int(index))
    }
    
    private func setTitle(index: Int){
        if let titleText = navigationItem.titleView as? UILabel{
            titleText.text = "  \(titles[index])"
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        let colors: [UIColor] = [.blue, .green, .yellow, .red]
        cell.backgroundColor = colors[indexPath.item]
        return cell
    }
    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return videos?.count ?? 0
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath) as! VideoCell
//
//        cell.video = videos?[indexPath.item]
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let height = (view.frame.width - 16 - 16) * 9 / 16
//        return CGSize(width: view.frame.width, height: height + 16 + 68)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
}













