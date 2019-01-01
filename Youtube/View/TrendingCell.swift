//
//  TrendingCell.swift
//  Youtube
//
//  Created by Dake Aga on 1/1/19.
//  Copyright © 2019 Dake Aga. All rights reserved.
//

import UIKit

class TrendingCell: FeedCell {
    override func fetchVideos() {
        API.sharedInstance.fetchTrendingVideos {  (videos: [Video]) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
}
