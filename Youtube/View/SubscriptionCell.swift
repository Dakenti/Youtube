//
//  SubscriptionCell.swift
//  Youtube
//
//  Created by Dake Aga on 1/1/19.
//  Copyright © 2019 Dake Aga. All rights reserved.
//

import UIKit

class SubscriptionCell: FeedCell {
    override func fetchVideos() {
        API.sharedInstance.fetchSubscriptionVideos {  (videos: [Video]) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
}
