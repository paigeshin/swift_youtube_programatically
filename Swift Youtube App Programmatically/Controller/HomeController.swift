//
//  ViewController.swift
//  Swift Youtube App Programmatically
//
//  Created by shin seunghyun on 2020/07/03.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var videos: [Video] = {
        
        var kanyeChannel = Channel()
        kanyeChannel.name = "KayneIsTheBestChannel"
        kanyeChannel.profileImagename = "profile"
        
        var blankSpaceVideo = Video()
        blankSpaceVideo.title = "Taylor Swift - Blank Space"
        blankSpaceVideo.thumbnailImageName = "thumbnail"
        blankSpaceVideo.channel = kanyeChannel
        blankSpaceVideo.numberOfViews = 23048933
        
        var badBloodVideo = Video()
        badBloodVideo.title = "Taylor Swift - Bad Blood featuing Kendrick Lamar"
        badBloodVideo.thumbnailImageName = "thumbnail"
        badBloodVideo.channel = kanyeChannel
        badBloodVideo.numberOfViews = 50435243
        
        return [blankSpaceVideo, badBloodVideo]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Navigation Controller Design */
        navigationItem.title = "Home"
        
        navigationController?.navigationBar.isTranslucent = false
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "Home"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        collectionView.backgroundColor = UIColor.white
    
        
        //Register Class Cell
        /*
         cell을 등록할 때
         UINib을 등록하는 방법이랑,
         class를 등록하는 방법이 있다.
         */
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: "cellId")
        
        /* Adjust Collection View Position */
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        /* SetupMenuBar */
        setupMenuBar()
        
        /* Set up Navbar buttons */
        setupNavBarButtons()
    }
    
    /* Set up Navbar buttons */
    func setupNavBarButtons() {
        //image names: magnifyingglass, bolt.circle
        let searchImage = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        searchImage?.withTintColor(UIColor.white)
        let moreImage = UIImage(systemName: "bolt.circle")?.withRenderingMode(.alwaysTemplate)
        moreImage?.withTintColor(UIColor.white)
        let searchBarButton = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        searchBarButton.tintColor = UIColor.white
        let moreButton = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(handleMore))
        moreButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItems = [searchBarButton, moreButton]
    }
    
    @objc func handleSearch() {
        print(123)
    }
    
    @objc func handleMore() {
        print(456)
    }
    
    /* Create Menubar */
    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:|[v0(50)]", views: menuBar)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Register Cell
        let cell: VideoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! VideoCell
        cell.video = videos[indexPath.row]
        return cell
    }
    
    //각각의 cell container의 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //16:9
        let leftSideContstant: CGFloat = 16
        let rightSideConstant: CGFloat = 16
        let ratio: CGFloat = 9 / 16
        let height: CGFloat = (view.frame.width - leftSideContstant - rightSideConstant) * ratio
        //16:9 thumnail을 만들기 위해서, height의 크기를 다른 contraint constant만큼 더해준다.
        return CGSize(width: view.frame.width, height: height + 16 + 88)
//        return CGSize(width: view.frame.width, height: 900)
//        return CGSize(width: view.frame.width, height: 500)
    }
    
    //각각 줄 간의 spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}


