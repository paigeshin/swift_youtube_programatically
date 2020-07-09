//
//  ViewController.swift
//  Swift Youtube App Programmatically
//
//  Created by shin seunghyun on 2020/07/03.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var videos: [Video]?
    
    func fetchVideos() {
        ApiService.sharedInstance.fetchVideos { (videos: [Video]) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Network */
        fetchVideos()
        
        /* Navigation Controller Design */
//        navigationItem.title = "Home"
        
        navigationController?.navigationBar.isTranslucent = false
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "  Home"
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
        // top에 만큼의 값을줌.
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        // top에 만큼의 값을줌.
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
        navigationItem.rightBarButtonItems = [moreButton, searchBarButton]
    }
    
    
    @objc func handleSearch() {
        print(123)
    }
    
    lazy var settingsLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.homeController = self
        return launcher
    }()
    
    @objc func handleMore() {
        //show menu
        settingsLauncher.showSettings()
    }
    
    /** Handle Event - Show ViewController For Settings Using navigation Controller **/
    func showControllerForSetting(setting: Setting) {
        /** Handle Event **/
        let dummySettingsViewController = UIViewController()
        dummySettingsViewController.view.backgroundColor = UIColor.white
        dummySettingsViewController.navigationItem.title = setting.name.rawValue
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.pushViewController(dummySettingsViewController, animated: true)
    }
    
    
    /* Create Menubar */
    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    private func setupMenuBar() {
        
        /* navigation controller option */
        navigationController?.hidesBarsOnSwipe = true
        
        /**
            navigationController?.hidesBarsOnSwipe = true
            원래 menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true, 이 코드를 적용하면
            menuBar를 제외한 navigation Controller가 hide 된다. 그 때, 중간에 비어있는 gap이 생기는데,  redView는 이 gap을 없애주려고 적용하는 코드다.
         
         **/
        let redView = UIView()
        redView.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 31)
        view.addSubview(redView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: redView)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: redView)
        
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:|[v0(50)]", views: menuBar)
        
        /** ios 13에서는 아래 코드가 작동하지 않는다. **/
        //아래와 같이 처리해주면, menuBar는 `navigationController.hidesBarsOnSwipe`를 true를 주더라도 사라지지 않고 무조건 safearea의 아래에 걸린다.
//        menuBar.topAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
    }

    
    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return videos?.count ?? 0
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        //Register Cell
//        let cell: VideoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! VideoCell
//        cell.video = videos![indexPath.row]
//        return cell
//    }
//
//    //각각의 cell container의 크기
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        //16:9
//        let leftSideContstant: CGFloat = 16
//        let rightSideConstant: CGFloat = 16
//        let ratio: CGFloat = 9 / 16
//        let height: CGFloat = (view.frame.width - leftSideContstant - rightSideConstant) * ratio
//        //16:9 thumnail을 만들기 위해서, height의 크기를 다른 contraint constant만큼 더해준다.
//        return CGSize(width: view.frame.width, height: height + 16 + 88)
////        return CGSize(width: view.frame.width, height: 900)
////        return CGSize(width: view.frame.width, height: 500)
//    }
//
//    //각각 줄 간의 spacing
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
    
}


