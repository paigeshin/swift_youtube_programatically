//
//  ViewController.swift
//  Swift Youtube App Programmatically
//
//  Created by shin seunghyun on 2020/07/03.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Home"
        collectionView.backgroundColor = UIColor.white
        //Register Class Cell
        /*
         cell을 등록할 때
         UINib을 등록하는 방법이랑,
         class를 등록하는 방법이 있다.
         */
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: "cellId")
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Register Cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)

        return cell
        
    }
    
    //각각의 cell container의 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    //각각 줄 간의 spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}

class VideoCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    let thumnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.blue
        return imageView
    }()
    
    let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.green
        return imageView
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.purple
        return label
    }()
    
    let subtitleTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false 
        textView.backgroundColor = UIColor.red
        return textView
    }()
    
    func setupViews() {
        self.addSubview(thumnailImageView)
        self.addSubview(seperatorView)
        self.addSubview(userProfileImageView)
        self.addSubview(titleLabel)
        self.addSubview(subtitleTextView)
        
        //분석을 해보니 -16- 은 각각의 constraint를 의미한다.
        //[object],  []사이에 있는 값들은 모두 view를 의미
        self.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: thumnailImageView)
        self.addConstraintsWithFormat(format: "H:|-16-[v0(44)]", views: userProfileImageView)
        self.addConstraintsWithFormat(format: "V:|-16-[v0]-8-[v1(44)]-16-[v2(1)]|", views: thumnailImageView, userProfileImageView, seperatorView)
        self.addConstraintsWithFormat(format: "H:|[v0]|", views: seperatorView)
        
        //top constraint
        self.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: thumnailImageView, attribute: .bottom, multiplier: 1, constant: 8))
        //left constraint
        self.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        //right constraint, align with thumnailImageView
        self.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: thumnailImageView, attribute: .right, multiplier: 1, constant: 0))
        //height constraint
        self.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 20))
        
        //top constraint
        self.addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 8))
        //left constraint
        self.addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        //right constraint, align with thumnailImageView
        self.addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .right, relatedBy: .equal, toItem: titleLabel, attribute: .right, multiplier: 1, constant: 0))
        //height constraint
        self.addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 20))
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIView {
    
    //parameter에 여러 object 넣을 수 있는 함수 만들기
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(
            //V:|-16-[v0]-16-|   =>   Vertically, top, bottom 0 contstant for each
            NSLayoutConstraint.constraints(withVisualFormat: format, // v0(1) => One pixel Tall
                                           options: NSLayoutConstraint.FormatOptions(),
                                           metrics: nil,
                                           views: viewsDictionary)
        )
    }
    
}
