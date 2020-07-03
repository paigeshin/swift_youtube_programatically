# swift_youtube_programatically

# Reference

[https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/AutolayoutPG/VisualFormatLanguage.html](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/AutolayoutPG/VisualFormatLanguage.html)

# Lecture - 1

[https://www.youtube.com/watch?v=3Xv1mJvwXok&list=PL0dzCUj1L5JGKdVUtA5xds1zcyzsz7HLj&index=1](https://www.youtube.com/watch?v=3Xv1mJvwXok&list=PL0dzCUj1L5JGKdVUtA5xds1zcyzsz7HLj&index=1)

- Initialize UICollectionViewController in SceneDelegate.swift
- Set up CollectionViewController
- Configure Custom Cell
- Swift Visual Format Language
- Refactoring

### Initialize Collection View Controller

ℹ️  CollectionView's default background color is `black`

- SceneDeleagte

```swift
var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let layout = UICollectionViewFlowLayout()
        window?.rootViewController = UINavigationController(rootViewController: HomeController(collectionViewLayout: layout))
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
```

### Basic Implementation

```swift
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
```

ℹ️  parameter 1개에 여러 object 넣을 수 있는 함수 만들기

```swift
//parameter에 여러 object 넣을 수 있는 함수 만들기
func addConstraintsWithFormat(format: String, view: UIView...) {
    
}
```

### Configure Custom Cell

- 분석을 해보니 "-16-" 은 각각의 constraint를 의미한다.
- `[object]`, []사이에 있는 값들은 모두 view를 의미

```swift
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
    
    let seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        return view
    }()
    
    func setupViews() {
        addSubview(thumnailImageView)
        addSubview(seperatorView)
        
        /** Draw Circle **/
        addConstraints(
            //H:|-16-[v0]-16-|   =>   Horizontally, leading, trailing 16 constant for each
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-16-|",
                                           options: NSLayoutConstraint.FormatOptions(),
                                           metrics: nil,
                                           views: ["v0": thumnailImageView])
        )
        addConstraints(
            //V:|-16-[v0]-16-|   =>   Vertically, top, bottom 16 contstant for each
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]-16-|",
                                           options: NSLayoutConstraint.FormatOptions(),
                                           metrics: nil,
                                           views: ["v0": thumnailImageView])
        )
        
        /** Add Line **/
        addConstraints(
            //H:|-16-[v0]-16-|   =>   Horizontally, leading, trailing 0 constant for each
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|",
                                           options: NSLayoutConstraint.FormatOptions(),
                                           metrics: nil,
                                           views: ["v0": seperatorView])
        )
        addConstraints(
            //V:|-16-[v0]-16-|   =>   Vertically, top, bottom 0 contstant for each
            NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(1)]|", // v0(1) => One pixel Tall
                                           options: NSLayoutConstraint.FormatOptions(),
                                           metrics: nil,
                                           views: ["v0": seperatorView])
        )
        
        //사이즈 정해주기
//        thumnailImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
```

### Loop Dictionary

```swift
var viewsDictionary = [String: UIView]()
for (index, view) in views.enumerated() {
    let key = "v\(index)"
    viewsDictionary[key] = view
}
```

⇒ 자동으로 `index` 값이 생성된다.
