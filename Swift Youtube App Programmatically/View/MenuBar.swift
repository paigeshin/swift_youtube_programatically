//
//  MenuBar.swift
//  Swift Youtube App Programmatically
//
//  Created by shin seunghyun on 2020/07/06.
//

import UIKit

class MenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    //lazy var를 써야지 cv.dataSource, cv.delegate를 적용할 수 있다.
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 31)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellId = "cellId"
    
    //나중에 component처럼 쓰고 싶다면 image name만 바꿔준다.
    let imageNames = ["house.fill", "square.and.arrow.down.on.square.fill", "pencil.circle.fill", "arrow.up.bin.fill"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        /* 맨 처음 화면이 rendering 됬을 때 선택된 부분을 보여주기 */
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .centeredHorizontally)
        
        setupHorizontalBar()
    }
    
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    
    //horizontal scrolling bar 설치
    func setupHorizontalBar() {
        
        //top menu bar에서 왼쪽, 오른쪽으로 움직이는 것을 표현.
        let horizontalBarView = UIView()
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        horizontalBarView.backgroundColor = UIColor(white: 0.9, alpha: 1) //투명 white background 만들기
        addSubview(horizontalBarView)
        
        //old school frame way of doing things
//        horizontalBarView.frame = CGRect(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
    
        //new school way of laying out our views
        //in iOS 9
        //need x, y, width, height constraints
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftAnchorConstraint?.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 8).isActive = true 
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        let x = CGFloat(indexPath.row) * frame.width / 4
        horizontalBarLeftAnchorConstraint?.constant = x
        
        //Apply SpringWithDamping Animation for natural rendering
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            UIView.animate(withDuration: 0.75) {
                self.layoutIfNeeded()
            }
        }, completion: nil)
        

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.imageView.image = UIImage(systemName: imageNames[indexPath.row])
        cell.tintColor = UIColor.rgb(red: 91, green: 14, blue: 13)
        /** Component **/
        //component로 만들 때는 아래 주석을 풀어주자
//        cell.imageView.image = UIImage(named: imageNames[indexPath.row])?.withRenderingMode(.alwaysTemplate)
        
        return cell
    }
    
    //각각의 메뉴의 크기를 정해줌.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 4, height: frame.height)
    }
    
    //각각 사이의 spacing을 제거해준다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MenuCell: BaseCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "house.fill")
        /** Component **/
        //component로 만들 때는 아래 주석을 풀어주자
//        iv.image = UIImage(named: "home")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor.rgb(red: 91, green: 14, blue: 13)
        return iv
    }()
    
    //When highlighted, change the color
    override var isHighlighted: Bool {
        didSet {
            imageView.tintColor = isHighlighted ? UIColor.white : UIColor.rgb(red: 91, green: 14, blue: 13)
        }
    }
    
    //When selected, change the color
    override var isSelected: Bool {
        didSet {
            imageView.tintColor = isSelected ? UIColor.white : UIColor.rgb(red: 91, green: 14, blue: 13)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        addSubview(imageView)
        addConstraintsWithFormat(format: "H:[v0(28)]", views: imageView)
        addConstraintsWithFormat(format: "V:[v0(28)]", views: imageView)
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
}

/** Component **/
//나중에 MenuBar을 component처럼 사용하고 싶다면... 아래 코드의 주석을 풀어준다.
//extension UIView {
//
//    //parameter에 여러 object 넣을 수 있는 함수 만들기
//    func addConstraintsWithFormat(format: String, views: UIView...) {
//
//        var viewsDictionary = [String: UIView]()
//        for (index, view) in views.enumerated() {
//            let key = "v\(index)"
//            view.translatesAutoresizingMaskIntoConstraints = false
//            viewsDictionary[key] = view
//        }
//
//        addConstraints(
//            //V:|-16-[v0]-16-|   =>   Vertically, top, bottom 0 contstant for each
//            NSLayoutConstraint.constraints(withVisualFormat: format, // v0(1) => One pixel Tall
//                                           options: NSLayoutConstraint.FormatOptions(),
//                                           metrics: nil,
//                                           views: viewsDictionary)
//        )
//    }
//
//}

