//
//  SubscriptionCell.swift
//  Swift Youtube App Programmatically
//
//  Created by shin seunghyun on 2020/07/10.
//

import UIKit

class SubscriptionCell: FeedCell {
    
    override func fetchVideos() {
        ApiService.sharedInstance.fetchSubscriptionFeed { (videos: [Video]) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
    
}
