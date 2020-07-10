//
//  FeedCell.swift
//  Swift Youtube App Programmatically
//
//  Created by shin seunghyun on 2020/07/10.
//

import UIKit

/* Feed를 담당. */
/* Cell안에서 또 다른 collectionView를 넣는것이 당연히 가능하다. */
class FeedCell: BaseCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //collectionView
    //lazy var: we can access `self` inside of closure
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    var videos: [Video]?
    
    let cellId = "cellId"
    
    func fetchVideos() {
        ApiService.sharedInstance.fetchVideos { (videos: [Video]) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
    
    override func setupViews() {
        super.setupViews()
     
        /* Network */
        fetchVideos()
        
        backgroundColor = .brown
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        /* Class를 등록할 경우에는 당연히 storyboard `identifer`를 지정해줄 필요가 없다. */
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Register Cell
        let cell: VideoCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! VideoCell
        cell.video = videos![indexPath.row]
        return cell
    }

    //각각의 cell container의 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //16:9
        let leftSideContstant: CGFloat = 16
        let rightSideConstant: CGFloat = 16
        let ratio: CGFloat = 9 / 16
        let height: CGFloat = (frame.width - leftSideContstant - rightSideConstant) * ratio
        //16:9 thumnail을 만들기 위해서, height의 크기를 다른 contraint constant만큼 더해준다.
        return CGSize(width: frame.width, height: height + 16 + 88)
//        return CGSize(width: view.frame.width, height: 900)
//        return CGSize(width: view.frame.width, height: 500)
    }

    //각각 줄 간의 spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
