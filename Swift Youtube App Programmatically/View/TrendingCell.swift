//
//  TrendingCell.swift
//  Swift Youtube App Programmatically
//
//  Created by shin seunghyun on 2020/07/10.
//

import UIKit

class TrendingCell: FeedCell {
    
    override func fetchVideos() {
       ApiService.sharedInstance.fetchTrendingVideo { (videos: [Video]) in
           self.videos = videos
           self.collectionView.reloadData()
       }
    }
    
}
