//
//  ViewController.swift
//  Swift Youtube App Programmatically
//
//  Created by shin seunghyun on 2020/07/03.
//

/* 메인 화면의 collectionView는 tabBar를 관리한다. */

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Navigation Controller Design */
//        navigationItem.title = "Home"
        
        navigationController?.navigationBar.isTranslucent = false
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "  Home"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        collectionView.backgroundColor = UIColor.white
    
        /* Set up CollectionView */
        setupCollectionView()
        
        /* Set up MenuBar */
        setupMenuBar()
        
        /* Set up Navbar buttons */
        setupNavBarButtons()
    }
    
    func setupCollectionView() {
        
        //menubar 각각 다른화면 rendering 해주기, horizontal scrolling
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        //Register Class Cell
        /*
         cell을 등록할 때
         UINib을 등록하는 방법이랑,
         class를 등록하는 방법이 있다.
         */
//        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: "cellId")
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        
        /* Adjust Collection View Position */
        // top에 만큼의 값을줌.
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        // top에 만큼의 값을줌.
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        collectionView.isPagingEnabled = true
        
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
        
    }
    
    //collectionView의 아이콘, 즉 custom tabbar icon을 클릭했을 시에 스크롤하게 한다.
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
        setTitleForIndex(index: menuIndex)
    }
    
    private func setTitleForIndex(index: Int) {
        /* Set Up Title */
        /** 기본적으로 navigationItem.titleView라는 값이 존재함. **/
        /** Menu 부분 활성화 sync 맞춰줌  **/
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = "  \(titles[index])"
        }
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
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    private func setupMenuBar() {
        
        /* navigation controller option */
//        navigationController?.hidesBarsOnSwipe = true
        
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

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //menubar control
        //menubar의 slidebar가 움직일 수 있도록함.
        //menuBar에 왼쪽 constraint가 잡혀있음. 그 값을 scrollView.content.x의 값을 넣으면 scroll할 때도 움직일 수 있도록 바꿀 수 있다.
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
//        let colors: [UIColor] = [.blue, .gray, .green, .cyan]
        
//        cell.backgroundColor = colors[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        /** feedCell의 화면이 살짝 바깥으로 나가서 최적화,   height: view.frame.height - 50 **/
        return CGSize(width: view.frame.width, height: view.frame.height - 50)
    }
    
    /** Set Up Title **/
    let titles = ["Home", "Trending", "Subscription", "Account"]
    
    //Synchronization when user scrolled, scrolling시 아이콘이 선택이 안되는데 아이콘 포지션을 잘 맞춰준다.
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        
        /* Set Up Title */
        /** 기본적으로 navigationItem.titleView라는 값이 존재함. **/
        setTitleForIndex(index: Int(index))
    }

}


