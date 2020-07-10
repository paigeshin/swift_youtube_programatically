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
       
        //window = UIWindow(frame: UIScreen.main.bounds)  ios13에서는 할 필요 없음. ios11일 경우 appDelegate에서 해준다.
        //window?.makeKeyAndVisible()
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

### Entire Code

- SceneDelegate.swift

```swift
//
//  SceneDelegate.swift
//  Swift Youtube App Programmatically
//
//  Created by shin seunghyun on 2020/07/03.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.makeKeyAndVisible()
        let layout = UICollectionViewFlowLayout()
        window?.rootViewController = UINavigationController(rootViewController: HomeController(collectionViewLayout: layout))
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

}
```

- HomeController

```swift
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
```

# Lecture - 2

- Custom Navigation Bar
- MVC Clean up

### clipsToBound

`clipsToBound = true`

```swift
imageView.clipsToBounds = true
```

⇒ 이미지가 bound 밖으로 나가지 못하게 함.

![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/30588180-f7e9-4602-96db-4dd547699c27/Untitled.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/30588180-f7e9-4602-96db-4dd547699c27/Untitled.png)

### masksToBounds

 `masksToBound = true` 

```swift
imageView.layer.cornerRadius = 22
imageView.layer.masksToBounds = true
```

⇒ masksToBounds를 적용해야 cornerRadius가 적용될 때가 있다.

### masksToBounds vs clipsToBounds

```jsx
imageView.clipsToBounds = true
imageView.layer.masksToBounds = true
```

- `clipsToBounds` 는 view의 property
- `masksToBounds` 는 layer의 property

**masksToBounds:** 

When the value of this property is `true`, Core Animation creates an implicit clipping mask that matches the bounds of the layer and includes any corner radius effects. If a value for the `[mask](https://developer.apple.com/documentation/quartzcore/calayer/1410861-mask)` property is also specified, the two masks are multiplied to get the final mask value.

The default value of this property is `false`.

**clipsToBounds:**

Setting this value to true causes subviews to be clipped to the bounds of the receiver. If set to false, subviews whose frames extend beyond the visible bounds of the receiver are not clipped. The default value is false.

⇒ 내가 적용해보니 둘 다 똑같은 기능을 하는 것 같다.

### textContainerInset

```swift
let subtitleTextView: UITextView = {
    let textView = UITextView()
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.text = "TaylerSwiftVEVO • 1,604,684,608 views • 2 years"
    //edge 추가
    textView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
    return textView
}()
```

### how to get 9:16 ratio

```swift
//각각의 cell container의 크기
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //16:9
    let leftSideContstant: CGFloat = 16
    let rightSideConstant: CGFloat = 16
    let ratio: CGFloat = 9 / 16
    let height: CGFloat = (view.frame.width - leftSideContstant - rightSideConstant) * ratio
    return CGSize(width: view.frame.width, height: height)
}
```

- 부족한 height값 추가해주기

```swift
//각각의 cell container의 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //16:9
        let leftSideContstant: CGFloat = 16
        let rightSideConstant: CGFloat = 16
        let ratio: CGFloat = 9 / 16
        let height: CGFloat = (view.frame.width - leftSideContstant - rightSideConstant) * ratio
        //16:9 thumnail을 만들기 위해서, height의 크기를 다른 contraint constant만큼 더해준다.
        return CGSize(width: view.frame.width, height: height + 16 + 68) //여기서 16, 68은 다른 것들이 차지하는 것을 의미한다.
    }
```

![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/cb7398b7-2990-4c89-8cb5-465318095949/Screen_Shot_2020-07-03_at_19.12.01.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/cb7398b7-2990-4c89-8cb5-465318095949/Screen_Shot_2020-07-03_at_19.12.01.png)

### Design UINavigationBar Programmatically

```swift
func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

// API below is only for less than iOS 13       
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.makeKeyAndVisible()

    let layout = UICollectionViewFlowLayout()
    window?.rootViewController = UINavigationController(rootViewController: HomeController(collectionViewLayout: layout))
    
    UINavigationBar.appearance().barTintColor = UIColor(red: 230/255, green: 32/255, blue: 31/255, alpha: 1)
    
    
    guard let _ = (scene as? UIWindowScene) else { return }
}
```

ℹ️  Swift Symbolic Language 

`V:|[v0(20)]|` 와 `V:|[v0(20)]` 의 차이. 

```swift
//swift format language에서 V:|[v0(20)]|를 하면, 마지막 constraint 값이 0이라는 의미다.
//swift format language에서 V:|[v0(20)]를 하면, 마지막 cosntraint 값이 없다.
window?.addConstraintsWithFormat(format: "V:|[v0(20)]", views: statusBarBackgroundView)
```

### Navigation Controller 꾸며주기

```swift
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
}
```

---

아래 정보들은 확실하지 않음, 그냥 참고만 할 것.

# Change statusBarStyle color

### **UIStatusBarManager**

An object describing the configuration of the status bar.

**Availability**

- iOS 13.0+
- Mac Catalyst 13.0+

**Framework**

- UIKit

**On This Page**[Declaration](https://developer.apple.com/documentation/uikit/uistatusbarmanager#declaration) [Overview](https://developer.apple.com/documentation/uikit/uistatusbarmanager#overview) [Topics](https://developer.apple.com/documentation/uikit/uistatusbarmanager#topics) [Relationships](https://developer.apple.com/documentation/uikit/uistatusbarmanager#relationships) [See Also](https://developer.apple.com/documentation/uikit/uistatusbarmanager#see-also)

### **UIStatusBarManager**

`class UIStatusBarManager : [NSObject](https://developer.apple.com/documentation/objectivec/nsobject)`

### **Overview**

Use a `UIStatusBarManager` object to get the current configuration of the status bar for its associated scene. You do not create `UIStatusBarManager` objects directly. Instead, you retrieve an existing object from the `[statusBarManager](https://developer.apple.com/documentation/uikit/uiwindowscene/3213943-statusbarmanager)` property of a `UIWindowScene` object.

You do not use this object to modify the configuration of the status bar. Instead, you set the status bar configuration individually for each of your `[UIViewController](https://developer.apple.com/documentation/uikit/uiviewcontroller)` objects. For example, to modify the default visibility of the status bar, override the `[prefersStatusBarHidden](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621440-prefersstatusbarhidden)` property of your view controller.

# Change status bar style using navigationBar

In a navigation controller situation, the color of the status bar is not determined by the view controller’s `preferredStatusBarStyle`.

It is determined, amazingly, by the navigation bar’s `barStyle`. To get light status bar text, say (in your view controller):

```swift
self.navigationController?.navigationBar.barStyle = .black

```

Hard to believe, but true. I got this info directly from Apple, years ago.

You can also perform this setting in the storyboard.

Example! Navigation bar's bar style is `.default`:

![https://i.stack.imgur.com/j6Mz2.png](https://i.stack.imgur.com/j6Mz2.png)

Navigation bar's bar style is `.black`:

![https://i.stack.imgur.com/DxqNb.png](https://i.stack.imgur.com/DxqNb.png)

**NOTE for iOS 13** This still works in iOS 13 as long as you don't use large titles or UIBarAppearance. But basically you are supposed to stop doing this and let the status bar color be automatic with respect to the user's choice of light or dark mode.

ℹ️  statusBar style can also be set by `Navigation Bar Style` 

# Change status bar color using `preferredStatusBarStyle`

info.plist

```swift
View controller-based status bar appearance : YES 

<key>UIViewControllerBasedStatusBarAppearance</key>
<true/>
```

```swift
override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
}
```

# Change statusbar style globally

info.plist 

```swift
View controller-based status bar appearance : NO 

<key>UIViewControllerBasedStatusBarAppearance</key>
<false/>
```

```swift
application.statusBarStyle = .lightContent
```

⇒ This is however deprecated. You must apply different statusBar style for each ViewController

# Change statusbar style on App Setting

![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/0e825b19-17ec-4ac4-9d6c-7f05bcb312d4/Screen_Shot_2020-07-06_at_15.06.07.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/0e825b19-17ec-4ac4-9d6c-7f05bcb312d4/Screen_Shot_2020-07-06_at_15.06.07.png)

### 특이한 현상 발견

```swift
window?.makeKeyAndVisible() //이 코드르 적용하면
//아래 코드가 작동하지 않는다.
UINavigationBar.appearance().barTintColor = UIColor.rgb(red: 230, green: 32, blue: 31) 
```

# Lecture - 3

- Custom Tab Bar / Menu Bar

### Programming Tricks

- navigationBar 간에 line 없애기

```swift
// get rid of black bar underneath navbar
UINavigationBar.appearance().shadowImage = UIImage()
UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
```

⇒ 빈 이미지를 적용한다.

ℹ️  Image에 rendering 모드 적용하기

```swift
UIImage(named: imageNames[indexPath.row])?.withRenderingMode(.alwaysTemplate)
```

⇒ 이렇게 해줘야 `tintColor` 등을 적용했을 때, 코드가 작동된다.

ℹ️  Cell에 기본적으로 제공되는 변수

```swift
//When highlighted, change the color
override var isHighlighted: Bool {
    didSet {
        imageView.tintColor = isHighlighted ? UIColor.white : UIColor.rgb(red: 91, green: 14, blue: 13)
    }
}

//When selected, change the color
override var isSelected: Bool {
    didSet {
        imageView.tintColor = isHighlighted ? UIColor.white : UIColor.rgb(red: 91, green: 14, blue: 13)
    }
}
```

# Menu Bar

### Menu Bar Installation

```swift
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
        
                /*** Menu Bar Installation ***/

        /* Adjust Collection View Position */
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        /* SetupMenuBar */
        setupMenuBar()
    }

        /*** Menu Bar Installation ***/    
    /* Create Menubar */
    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()

        /*** Menu Bar Installation ***/    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:|[v0(50)]", views: menuBar)
    }
```

### Menu Bar

```swift
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
```
# Lecture 4

# Model - View - Controller

# Set up `Search` or `More`

```swift
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
```

**ℹ️  Number Formatter**

```swift
if let channelName = video?.channel?.name, let numberOfViews = video?.numberOfViews {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    
    let subtitleText = "\(channelName) • \(numberFormatter.string(from: numberOfViews)!) • 2 years ago"
    subtitleTextView.text = subtitleText
}
```

⇒ 자동으로 000 마다 `,` 를 추가해준다.

### Label 크기 가져오기

`NSString` `boundingRect()` 을 쓰면 rectangle의 값을 가져올 수 있다.

```swift
/** Dynamically change constraint **/
  //measure title text
  if let title = video?.title {
      /*
       16: left constraint
       44: profile constraint (width)
       8: space between profile and title
       16: right constraint
       => Label Size
       */
      let size = CGSize(width: frame.width - 16 - 44 - 8 - 16, height: 1000)
      let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
      /* boundingRect라는 함수를 호출하여 크기를 가져올 수 있다. */
      let estimatedRect = NSString(string: title)
          .boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
      if estimatedRect.size.height > 20 {
          titleLabelHeightConstraint?.constant = 44
      } else {
          titleLabelHeightConstraint?.constant = 20
      }
  }
```
# Lecture 5

[https://www.youtube.com/watch?v=WjrvcGAZfoI&list=PL0dzCUj1L5JGKdVUtA5xds1zcyzsz7HLj&index=5](https://www.youtube.com/watch?v=WjrvcGAZfoI&list=PL0dzCUj1L5JGKdVUtA5xds1zcyzsz7HLj&index=5)

# REST JSON Integration via `NSURLSession`

### String 형식으로 데이터 받아오는 방법

```swift
let url: URL? = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            //String 형식으로 서버 response 받아오는 방법
                        let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        print(str)
              }.resume()
```

### SwiftyJSON처럼 json 데이터 가져오는 방법

```swift
let url: URL? = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            do {
                /* Mutable Containers -> 바뀔 수 있는 데이터를 암시함. */
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                
                self.videos = [Video]()
                
                //dictionary 형식으로 가져온다. 마치 SwiftyJson과 비슷함.
                for dictionary in json as! [[String: AnyObject]] {
                    let video = Video()
                    video.title = dictionary["title"] as? String
                    video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
                    self.videos?.append(video)
                }
                
            } catch let jsonError {
                print(jsonError)
            }
        
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
            //String 형식으로 서버 response 받아오는 방법
//            let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            print(str)
            
        }.resume()
```

ℹ️   Optional Count Handling 하는 방법

```swift
override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if let count = videos?.count {
        return count
    }
    return 0
}

//또는...
override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos?.count ?? 0
}
```

### URL을 통해서 Image 가져오는 방법

```swift
func setupThumbnailImage() {
    if let thumbnailImageUrl = video?.thumbnailImageName {
        
        let url = URL(string: thumbnailImageUrl)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                self.thumnailImageView.image = UIImage(data: data!)
            }
            
        }.resume()
        
        print(thumbnailImageUrl)
    }
}
```

```swift
extension UIImageView {
    
    func loadImageUsingUrlString(urlString: String){
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }.resume()
    }
    
}
```

# Lecture - 6

[https://www.youtube.com/watch?v=XFvs6eraBXM&list=PL0dzCUj1L5JGKdVUtA5xds1zcyzsz7HLj&index=6](https://www.youtube.com/watch?v=XFvs6eraBXM&list=PL0dzCUj1L5JGKdVUtA5xds1zcyzsz7HLj&index=6)

**ℹ️  DispatchQueue.main.async** 

⇒ concurrent하게 돌다가 다시 main 으로 돌아와라, 라는 뜻임.

```swift
func loadImageUsingUrlString(urlString: String){
        let url = URL(string: urlString)
        //가장 처음에 로딩될 때, 해당되는 이미지가 로딩아 안되는 경우가 있어서 `nil`값을 줘서 제대로 출력되게 만든다.
        image = nil
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }.resume()
    }
```

### Image Caching - Faster Loading

```swift
//Image Cache, 로딩한 이미지를 저장함. 나중에 더 빠르게 로딩하기 위해서다.

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImageUsingUrlString(urlString: String){
        let url = URL(string: urlString)
        //가장 처음에 로딩될 때, 해당되는 이미지가 로딩아 안되는 경우가 있어서 `nil`값을 줘서 제대로 출력되게 만든다.
        image = nil
        if let imageFromCache = imageCache.object(forKey: NSString(string:urlString)) {
            self.image = imageFromCache
            return
        }
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data!)
                imageCache.setObject(imageToCache!, forKey: NSString(string: urlString))
                self.image = imageToCache
            }
        }.resume()
    }
    
}
```

### Extension을 만드는 또 다른 방법

- class 만들기, image Caching 및 correct position에 이미지 뿌려주기.

```swift
//Image Cache, 로딩한 이미지를 저장함. 나중에 더 빠르게 로딩하기 위해서다.

let imageCache = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingUrlString(urlString: String){
        
        imageUrlString = urlString
        
        let url = URL(string: urlString)
        //가장 처음에 로딩될 때, 해당되는 이미지가 로딩아 안되는 경우가 있어서 `nil`값을 줘서 제대로 출력되게 만든다.
        image = nil
        if let imageFromCache = imageCache.object(forKey: NSString(string:urlString)) {
            self.image = imageFromCache
            return
        }
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data!)
                
                //imageUrl string과 parameter로 들어온 urlString이 같은 값일때 로딩하게 하면, collectionView나 tableView 특성 때문에 이상하게 데이터가 출력되는 경우를 방지할 수 있다.
                if self.imageUrlString == urlString {
                    imageCache.setObject(imageToCache!, forKey: NSString(string: urlString))
                }
                
                self.image = imageToCache
            }
        }.resume()
    }
    
}
```

- 적용

```swift
let thumnailImageView: CustomImageView = {
    let imageView = CustomImageView()
    imageView.image = UIImage(named: "thumbnail")!
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
}()

let userProfileImageView: CustomImageView = {
    let imageView = CustomImageView()
    imageView.image = UIImage(named: "profile")!
    imageView.layer.cornerRadius = 22
    imageView.layer.masksToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    return imageView
}()
```
# Lecture - 7, 8, 9

[https://www.youtube.com/watch?v=2kwCfFG5fDA&list=PL0dzCUj1L5JGKdVUtA5xds1zcyzsz7HLj&index=7](https://www.youtube.com/watch?v=2kwCfFG5fDA&list=PL0dzCUj1L5JGKdVUtA5xds1zcyzsz7HLj&index=7)

[https://www.youtube.com/watch?v=PNmuTTd5zWc&list=PL0dzCUj1L5JGKdVUtA5xds1zcyzsz7HLj&index=8](https://www.youtube.com/watch?v=PNmuTTd5zWc&list=PL0dzCUj1L5JGKdVUtA5xds1zcyzsz7HLj&index=8)

# Swift Slide-In Menu

- Cover up entire screen

```swift
@objc func handleMore() {
        //show menu
        /*
         'keyWindow' was deprecated in iOS 13.0: Should not be used for applications that support multiple scenes as it returns a key window across all connected scenes
         => 즉, multiple scene을 support하지 않으면 써도 됨.
         */
        if let window = UIApplication.shared.keyWindow {
            let blackView = UIView()
            blackView.backgroundColor = UIColor.black
            window.addSubview(blackView)
            blackView.frame = window.frame
        }
    }
```

- Basic Code

```swift
@objc func handleMore() {
        //show menu
        /*
         'keyWindow' was deprecated in iOS 13.0: Should not be used for applications that support multiple scenes as it returns a key window across all connected scenes
         => 즉, multiple scene을 support하지 않으면 써도 됨.
         */
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            //view.addSubview를 사용해도 된다.
            blackView.frame = window.frame
            blackView.alpha = 0
            UIView.animate(withDuration: 0.5) {
                self.blackView.alpha = 1
            }
        }
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
        }
    }
```

ℹ️  iOS 13에서 keywindow 집어오는 방법

```swift
//ios 13
guard let window = UIApplication.shared.connectedScenes
.filter({$0.activationState == .foregroundActive})
.map({$0 as? UIWindowScene})
.compactMap({$0})
.first?.windows
.filter({$0.isKeyWindow}).first
else {
        return
}

//ios less than 13 
let window = UIApplication.shared.keyWindow
```

- keywindow ios 13버전

```swift
let blackView = UIView()

@objc func handleMore() {
        //show menu
        /*
         'keyWindow' was deprecated in iOS 13.0: Should not be used for applications that support multiple scenes as it returns a key window across all connected scenes
         => 즉, multiple scene을 support하지 않으면 써도 됨.
         */
        guard let window = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
        else {
                return
        }
        
//        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            //view.addSubview를 사용해도 된다.
            blackView.frame = window.frame
            blackView.alpha = 0
            UIView.animate(withDuration: 0.5) {
                self.blackView.alpha = 1
            }
//        }
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
        }
    }
```

### Component 화

```swift
//
//  SettingLauncher.swift
//  Swift Youtube App Programmatically
//
//  Created by shin seunghyun on 2020/07/07.
//

import UIKit

class SettingsLauncher: NSObject {
    
    override init() {
        super.init()
        //start doing something here...
    }
    
    let blackView = UIView()
    
    @objc func showSettings() {
        //show menu
        /*
         'keyWindow' was deprecated in iOS 13.0: Should not be used for applications that support multiple scenes as it returns a key window across all connected scenes
         => 즉, multiple scene을 support하지 않으면 써도 됨.
         */
        guard let window = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
        else {
                return
        }
        
//        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            //view.addSubview를 사용해도 된다.
            blackView.frame = window.frame
            blackView.alpha = 0
            UIView.animate(withDuration: 0.5) {
                self.blackView.alpha = 1
            }
//        }
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
        }
    }
    
}
```

- how to load component

```swift
let settingsLauncher = SettingsLauncher()

@objc func handleMore() {
    //show menu
    settingsLauncher.showSettings()
}
```

- apply spring damping animation

```swift
/* Set Contents, apply SpringWitnDamping */
UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
    /* Set Contents, animation 추가 */
    self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
}, completion: nil)
```

# Add Animation & Rectangle to the component, complete code

```swift
//
//  SettingLauncher.swift
//  Swift Youtube App Programmatically
//
//  Created by shin seunghyun on 2020/07/07.
//

import UIKit

class SettingsLauncher: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let blackView = UIView()
    
      /* Set Contents */
    let myCollectionView: UICollectionView = {
         let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
         layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
         layout.itemSize = CGSize(width: 60, height: 60)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    /* Set Menu Items */
    let cellId = "settingCell"
        
    func showSettings() {
    
        //show menu
        /*
         'keyWindow' was deprecated in iOS 13.0: Should not be used for applications that support multiple scenes as it returns a key window across all connected scenes
         => 즉, multiple scene을 support하지 않으면 써도 됨.
         */
//                let window = UIApplication.shared.keyWindow!
        guard let window = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
        else {
                return
        }
        
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5) //투명 background 값 주기
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
        window.addSubview(blackView)
        /* Set Contents, 실제 contents를 넣을 view를 그려주고 y 값을 지정해준다.. */
        window.addSubview(collectionView)
        
        let height: CGFloat = 200
        let y = window.frame.height - height
        
        /* Set Contents */
        //initial value는 y값을 fullsize로 준다. 왜냐하면, animation을 주기 위해서다. 아래서 위로 올라오는 animation 만들기
        collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
        
        blackView.frame = window.frame
        blackView.alpha = 0
        
        /* Set Contents, apply SpringWitnDamping */
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 1
            /* Set Contents, animation 추가 */
            /* collectionView의 크기를 정해준다. */
            self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: height)
        }) { (done) in
            if done {
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc func handleDismiss() {
        
        guard let window = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
        else {
                return
        }
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            /* Set Contents, set animation */
            self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
        }
        
    }
    
    

    /* Set Menu Items */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("returning items!")
        return 3
    }
    
    /* Set Menu Items */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cellForItemAt called!")
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        print("populating cell!")
        cell.backgroundColor = .black
        return cell
    }
    
    /* Set Menu Items */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("CGSize called")
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    override init() {
        super.init()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: cellId)
        
//        addConstraintsWithFormat(format: "H:-16-[v0(30)]-8-[v1]|", views: iconImageView, nameLabel)
//        addConstraintsWithFormat(format: "V:|[v0]|", views: nameLabel)
//        addConstraintsWithFormat(format: "V:[v0(30)]", views: iconImageView)
//        collectionView.addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
//        collectionView.addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
    }
    
    

}
```

# Add Setting Menu

ℹ️  NSObject를 상속 받았을 경우, `protocol`  을 가져와서 쓸 수 있다.

### Create UICollectionView Programmatically

```swift
/* Set Contents */
let collectionView: UICollectionView = {
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    layout.itemSize = CGSize(width: 60, height: 60)
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.backgroundColor = .white
    return cv
}()
```

- `UICollectionViewLayout()` 이 아니라 `UICollectionviewFlowLayout()` 을 넣어야한다.

⇒ 이거때문에 거의 4시간 날림.

### Complete

- SettingCell.swift

```swift
//
//  SettingCell.swift
//  Swift Youtube App Programmatically
//
//  Created by shin seunghyun on 2020/07/07.
//

import UIKit

class SettingCell: BaseCell {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.white
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            iconImageView.tintColor = isHighlighted ? UIColor.white : UIColor.darkGray
        }
    }
    
    var setting: Setting? {
        didSet {
            nameLabel.text = setting?.name
            if let imageName = setting?.imageName {
                iconImageView.image = UIImage(systemName: imageName)
                iconImageView.tintColor = UIColor.darkGray
            }
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Setting"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "folder.fill")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override func setupViews() {
        super.setupViews()
        addSubview(nameLabel)
        addSubview(iconImageView)
        addConstraintsWithFormat(format: "H:|-16-[v0(30)]-16-[v1]|", views: iconImageView, nameLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: nameLabel)
        addConstraintsWithFormat(format: "V:[v0(30)]", views: iconImageView)
        
        //center Y로 정렬하기
        addConstraint(NSLayoutConstraint(
            item: iconImageView,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: 1,
            constant: 0))
        
    }
    
}
```

- SettingLauncher

```swift
//
//  SettingLauncher.swift
//  Swift Youtube App Programmatically
//
//  Created by shin seunghyun on 2020/07/07.
//

import UIKit

/** Component화 한다면 바꿔줘야하는 것들 **/
class Setting: NSObject {
    
    let name: String
    let imageName: String
    
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
    
}

class SettingsLauncher: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let blackView = UIView()
    
    /* Set Contents */
    let collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        /* Constraint를 추가했으니 아래 값이 굳이 필요가 없다. */
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//        layout.itemSize = CGSize(width: 30, height: 30)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.collectionViewLayout.invalidateLayout()
        cv.isScrollEnabled = false 
        return cv
    }()
    
    /* Set Menu Items */
    let cellId = "powerCell"
    let cellHeight: CGFloat = 50
        
    /** Component화 한다면 바꿔줘야하는 것들 **/
    /* Set Menu Items */
    let settings: [Setting] = {
        return [
            Setting(name: "Settings", imageName: "square.and.arrow.up"),
            Setting(name: "Terms & Privacy", imageName: "square.and.arrow.down"),
            Setting(name: "Send Feedback", imageName: "speaker.zzz"),
            Setting(name: "Help", imageName: "cloud.sun.rain"),
            Setting(name: "Switch Account", imageName: "moon.fill"),
            Setting(name: "Cancel", imageName: "xmark.seal")
        ]
    }()
    
    func showSettings() {
    
        //show menu
        /*
         'keyWindow' was deprecated in iOS 13.0: Should not be used for applications that support multiple scenes as it returns a key window across all connected scenes
         => 즉, multiple scene을 support하지 않으면 써도 됨.
         */
//                let window = UIApplication.shared.keyWindow!
        guard let window = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
        else {
            return
        }
        
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5) //투명 background 값 주기
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
        window.addSubview(blackView)
        /* Set Contents, 실제 contents를 넣을 view를 그려주고 y 값을 지정해준다.. */
        window.addSubview(collectionView)
        
        /** Set Menu Items **/
        /* Make dynamic Height for Menu Height */
        let height: CGFloat = CGFloat(settings.count) * cellHeight
        
        let y = window.frame.height - height
        
        /* Set Contents */
        //initial value는 y값을 fullsize로 준다. 왜냐하면, animation을 주기 위해서다. 아래서 위로 올라오는 animation 만들기
        collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
        
        blackView.frame = window.frame
        blackView.alpha = 0
        
        /* Set Contents, apply SpringWitnDamping */
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 1
            /* Set Contents, animation 추가 */
            /* collectionView의 크기를 정해준다. */
            self.collectionView.frame = CGRect(x: 0,
                                               y: y,
                                               width: self.collectionView.frame.width,
                                               height: height)
        }, completion: nil)
    }
    
    @objc func handleDismiss() {
        
        guard let window = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
        else {
                return
        }
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            /* Set Contents, set animation */
            self.collectionView.frame = CGRect(x: 0,
                                               y: window.frame.height,
                                               width: self.collectionView.frame.width,
                                               height: self.collectionView.frame.height)
        }
        
    }
    /* Set Menu Items */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    /* Set Menu Items */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    

    /* Set Menu Items */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SettingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "powerCell", for: indexPath) as! SettingCell
        cell.setting = settings[indexPath.row]
        return cell
    }
    
    override init() {
        super.init()
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: "powerCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }

}
```

- apply

```swift
let settingsLauncher = SettingsLauncher()
    
@objc func handleMore() {
    //show menu
    settingsLauncher.showSettings()
}
```

# Handle Click for menus

[https://www.youtube.com/watch?v=DYsfAD01fYk&list=PL0dzCUj1L5JGKdVUtA5xds1zcyzsz7HLj&index=9](https://www.youtube.com/watch?v=DYsfAD01fYk&list=PL0dzCUj1L5JGKdVUtA5xds1zcyzsz7HLj&index=9)

### What does it mean to `lazy` instantiate a variable in Swift?

- Not executing the code until it is called
- It only gets called once

**ℹ️.  Navigation Controller programmatically**

```swift
let dummySettingsViewController = UIViewController()
navigationController?.pushViewController(dummySettingsViewController, animated: true)
```

### Attach Events for navigation push

- SettingsLauncher

```swift
var homeController: HomeController?

/* Handle Events */
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    guard let window = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
        else {
            return
    }
    
    //SpringWithDamping
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
        self.blackView.alpha = 0
        /* Set Contents, set animation */
        self.collectionView.frame = CGRect(x: 0,
                                           y: window.frame.height,
                                           width: self.collectionView.frame.width,
                                           height: self.collectionView.frame.height)
    }) { (completed) in
        /* Handle Menu when menu is clicked */
        let setting = self.settings[indexPath.row]
        if setting.name != "Cancel" {
                        //show Settings
            self.homeController?.showControllerForSetting(setting: setting)
        }
    }

}
```

- HomeController

```swift
//lazy var를 사용했기 때문에 딱 1번만 initialize 됨
lazy var settingsLauncher: SettingsLauncher = {
    let launcher = SettingsLauncher()
    launcher.homeController = self
    return launcher
}()

@objc func handleMore() {
  //show menu
  settingsLauncher.showSettings()
  
//        showControllerForSettings()
  
}
```

# Lecture - 10 

# How to Use Enumerations to Prevent Bugs

### Enumeration

- An enumeration defines a common type for a group of related values and enables you to work with those values in a `type-safe way` within your code.

### text enum example

```swift
label.textAlignment = .left //Swift enum example
```

### Enum 적용

```swift
enum SettingName: String {
    case Cancel = "Cancel"
    case Setting = "Setting"
    case TermsPrivacy = "Terms & Privacy"
    case SendFeedback = "Send Feedback"
    case Help = "Help"
    case SwitchAccount = "Swift Account"   
}

class Setting: NSObject {
    
    let name: SettingName
    let imageName: String
    
    init(name: SettingName, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
    
}

let settings: [Setting] = {
        let settingSettings = Setting(name: .Setting, imageName: "square.and.arrow.up")
        let termsAndPrivacySettings = Setting(name: .TermsPrivacy, imageName: "square.and.arrow.down")
        let sendFeedbackSettings = Setting(name: .SendFeedback, imageName: "speaker.zzz")
        let helpSettings = Setting(name: .Help, imageName: "cloud.sun.rain")
        let switchAccount = Setting(name: .SwitchAccount, imageName: "square.and.arrow.up")
        let cancelSettings = Setting(name: .Cancel, imageName: "xmark.seal")
        return [
            settingSettings,
            termsAndPrivacySettings,
            sendFeedbackSettings,
            helpSettings,
            switchAccount,
            cancelSettings
        ]
    }()
```
# Lecture - 11

[https://www.youtube.com/watch?v=XgRbj4YeG9I&list=PL0dzCUj1L5JGKdVUtA5xds1zcyzsz7HLj&index=11](https://www.youtube.com/watch?v=XgRbj4YeG9I&list=PL0dzCUj1L5JGKdVUtA5xds1zcyzsz7HLj&index=11)

# Swipe Away Navigation Bar, Menu Bar Slider Animation

ℹ️  `hidesBarOnSwipe` , one of animations for Navigation Bar 

```swift
/* navigation controller option */
navigationController?.hidesBarsOnSwipe = true
```

### Horizontal Scroll Bar를 만들고 움직이게 하는 방법, 잘 적용하면 어떤 화면에서도 써먹을 수 있음.

```swift
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
```

### Create SingleTon API Service

```swift
//
//  ApiService.swift
//  Swift Youtube App Programmatically
//
//  Created by shin seunghyun on 2020/07/09.
//

import UIKit

class ApiService: NSObject {

    static let sharedInstance = ApiService()
    
    func fetchVideos(completion: @escaping([Video]) -> ()) {
        let url: URL? = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            do {
                /* Mutable Containers -> 바뀔 수 있는 데이터를 암시함. */
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                var videos = [Video]()
                //dictionary 형식으로 가져온다. 마치 SwiftyJson과 비슷함.
                for dictionary in json as! [[String: AnyObject]] {
                    let video = Video()
                    video.title = dictionary["title"] as? String
                    video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
                    let channelDictionary = dictionary["channel"] as! [String: AnyObject]
                    let channel = Channel()
                    channel.name = channelDictionary["name"] as? String
                    channel.profileImagename = channelDictionary["profile_image_name"] as? String
                    video.channel = channel
                    videos.append(video)
                }
                
                DispatchQueue.main.async {
                    completion(videos)
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            

            
            //String 형식으로 서버 response 받아오는 방법
//            let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            print(str)
        }.resume()
    }
    
}
```

ℹ️  Closure의 parameter에 data type 지정해주기

```swift
func fetchVideos() {
    ApiService.sharedInstance.fetchVideos { (videos: [Video]) in
        self.videos = videos
                self.collectionView.reloadData()
    }
}
```

# Lecture 12

### ❓ From within a ScrollView, how do we know where the scroll location is? ❓

```swift
override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //menubar control
        //menubar의 slidebar가 움직일 수 있도록함.
        //menuBar에 왼쪽 constraint가 잡혀있음. 그 값을 scrollView.content.x의 값을 넣으면 scroll할 때도 움직일 수 있도록 바꿀 수 있다.
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
    }
```

### Sync with Screen

- HomeController.swift

```swift
/* Create Menubar */
lazy var menuBar: MenuBar = {
    let mb = MenuBar()
    mb.homeController = self
    return mb
}()

//collectionView의 아이콘, 즉 custom tabbar icon을 클릭했을 시에 스크롤하게 한다.
func scrollToMenuIndex(menuIndex: Int) {
    let indexPath = IndexPath(item: menuIndex, section: 0)
    collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
}

//Synchronization when user scrolled, scrolling시 아이콘이 선택이 안되는데 아이콘 포지션을 잘 맞춰준다.
override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let index = targetContentOffset.pointee.x / view.frame.width
    let indexPath = IndexPath(item: Int(index), section: 0)
    menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
}
```

⇒ 이런 방식을 사용하게 되면 굳이 delegate protocol을 사용하지 않아도 되게됨.

- MenuBar.swift

```swift
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
//        let x = CGFloat(indexPath.row) * frame.width / 4
//        horizontalBarLeftAnchorConstraint?.constant = x
        
        //Apply SpringWithDamping Animation for natural rendering
//        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            UIView.animate(withDuration: 0.75) {
//                self.layoutIfNeeded()
//            }
//        }, completion: nil)
        
        /** 이부분이 중요하다 **/
                /** 윗 부분 애니메이션 부분이 주석처리된 이유는 homeController에서 scrollToPosition을 사용해줬기 때문이다. **/
        homeController?.scrollToMenuIndex(menuIndex: indexPath.row)
    }
```
# Lecture 13

[https://www.youtube.com/watch?v=elvK3TYnzIw&t=1s](https://www.youtube.com/watch?v=elvK3TYnzIw&t=1s)

ℹ️  `lazy var`

- lazy var: we can access `self` inside of closure

### HomeController

- Set Up Title

```swift
//collectionView의 아이콘, 즉 custom tabbar icon을 클릭했을 시에 스크롤하게 한다.
func scrollToMenuIndex(menuIndex: Int) {
    let indexPath = IndexPath(item: menuIndex, section: 0)
    collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
    
    /* Set Up Title */
    /** 기본적으로 navigationItem.titleView라는 값이 존재함. **/
    /** Menu 부분 활성화 sync 맞춰줌  **/
    if let titleLabel = navigationItem.titleView as? UILabel {
        titleLabel.text = "  \(titles[menuIndex])"
    }
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
    if let titleLabel = navigationItem.titleView as? UILabel {
        titleLabel.text = "  \(titles[indexPath.row])"
    }
}
```

### Refactoring

```swift
/** Set Up Title **/
let titles = ["Home", "Trending", "Subscription", "Account"]

private func setTitleForIndex(index: Int) {
    /* Set Up Title */
    /** 기본적으로 navigationItem.titleView라는 값이 존재함. **/
    /** Menu 부분 활성화 sync 맞춰줌  **/
    if let titleLabel = navigationItem.titleView as? UILabel {
        titleLabel.text = "  \(titles[index])"
    }
}

override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //menubar control
    //menubar의 slidebar가 움직일 수 있도록함.
    //menuBar에 왼쪽 constraint가 잡혀있음. 그 값을 scrollView.content.x의 값을 넣으면 scroll할 때도 움직일 수 있도록 바꿀 수 있다.
    menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
}

//Synchronization when user scrolled, scrolling시 아이콘이 선택이 안되는데 아이콘 포지션을 잘 맞춰준다.
override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let index = targetContentOffset.pointee.x / view.frame.width
    let indexPath = IndexPath(item: Int(index), section: 0)
    menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    
    /* Set Up Title */
    /** 기본적으로 navigationItem.titleView라는 값이 존재함. **/
    setTitleForIndex(index: Int(index))
}
```
### FeedCell

```swift
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
```
### CollectionView 최적화

```swift
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    /** feedCell의 화면이 살짝 바깥으로 나가서 최적화,   height: view.frame.height - 50 **/
    return CGSize(width: view.frame.width, height: view.frame.height - 50)
}
```

# Lecture 14

[https://www.youtube.com/watch?v=77nQN0JzBH4](https://www.youtube.com/watch?v=77nQN0JzBH4)

# Create Other Tabbar Contents - Trending Cell

### Add `fetchTrendingVideo()` onto `APIService`

```swift
func fetchTrendingVideo(completion: @escaping([Video]) -> ()) {
        let url: URL? = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/trending.json")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            do {
                /* Mutable Containers -> 바뀔 수 있는 데이터를 암시함. */
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                var videos = [Video]()
                //dictionary 형식으로 가져온다. 마치 SwiftyJson과 비슷함.
                for dictionary in json as! [[String: AnyObject]] {
                    let video = Video()
                    video.title = dictionary["title"] as? String
                    video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
                    let channelDictionary = dictionary["channel"] as! [String: AnyObject]
                    let channel = Channel()
                    channel.name = channelDictionary["name"] as? String
                    channel.profileImagename = channelDictionary["profile_image_name"] as? String
                    video.channel = channel
                    videos.append(video)
                }
                
                DispatchQueue.main.async {
                    completion(videos)
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            

            
            //String 형식으로 서버 response 받아오는 방법
//            let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            print(str)
        }.resume()
    }
```

ℹ️  Code로 navigationController 이용하는 법.. (segue 없이)

```swift
let dummySettingsViewController = UIViewController()
dummySettingsViewController.view.backgroundColor = UIColor.white
dummySettingsViewController.navigationItem.title = setting.name.rawValue
navigationController?.navigationBar.tintColor = UIColor.white
navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
navigationController?.pushViewController(dummySettingsViewController, animated: true)
```

### CollectionView를 이용해서 custom tabbar를 만들시에...

- register cells

```swift
let cellId = "cellId"
let trendingCellId = "trendingCellId"
let subscriptionCellId = "subscriptionCellId"
```

- return cell dynamically

```swift
override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    let FIRST_SCENE = 0
    let SECOND_SCENE = 1
    let THIRD_SCENE = 2

    let identifier: String
    
    if indexPath.row == FIRST_SCENE {
        identifier = cellId
    } else if indexPath.row == SECOND_SCENE {
        identifier = trendingCellId
    } else if indexPath.row == THIRD_SCENE {
        identifier = subscriptionCellId
    } else { //default value
        identifier = cellId
    }
        
    //FIRST_SCENE이 default임.
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    
    return cell

}
```

### API Service Refactoring

```swift
//
//  ApiService.swift
//  Swift Youtube App Programmatically
//
//  Created by shin seunghyun on 2020/07/09.
//

import UIKit

class ApiService: NSObject {

    static let sharedInstance = ApiService()
    
    let baseURL = "https://s3-us-west-2.amazonaws.com/youtubeassets"
    
    func fetchVideos(completion: @escaping([Video]) -> ()) {
        fetchFeedForUrlString(urlString: "\(baseURL)/home.json", completion: completion)
    }
    
    func fetchTrendingVideo(completion: @escaping([Video]) -> ()) {
        fetchFeedForUrlString(urlString: "\(baseURL)/trending.json", completion: completion)
    }
    
    func fetchSubscriptionFeed(completion: @escaping([Video]) -> ()) {
        fetchFeedForUrlString(urlString: "\(baseURL)/subscriptions.json", completion: completion)
    }
    
    func fetchFeedForUrlString(urlString: String, completion: @escaping([Video]) -> ()) {
        let url: URL? = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            do {
                /* Mutable Containers -> 바뀔 수 있는 데이터를 암시함. */
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                var videos = [Video]()
                //dictionary 형식으로 가져온다. 마치 SwiftyJson과 비슷함.
                for dictionary in json as! [[String: AnyObject]] {
                    let video = Video()
                    video.title = dictionary["title"] as? String
                    video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
                    let channelDictionary = dictionary["channel"] as! [String: AnyObject]
                    let channel = Channel()
                    channel.name = channelDictionary["name"] as? String
                    channel.profileImagename = channelDictionary["profile_image_name"] as? String
                    video.channel = channel
                    videos.append(video)
                }
                DispatchQueue.main.async {
                    completion(videos)
                }
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }
    
}
```
# Lecture 15 - JSON Parse, deprecated

[https://www.youtube.com/watch?v=11aHute59QQ&list=PL0dzCUj1L5JGKdVUtA5xds1zcyzsz7HLj&index=15](https://www.youtube.com/watch?v=11aHute59QQ&list=PL0dzCUj1L5JGKdVUtA5xds1zcyzsz7HLj&index=15)

### setValuesForKeys

```swift
//
//  Video.swift
//  Swift Youtube App Programmatically
//
//  Created by shin seunghyun on 2020/07/06.
//

import UIKit

class Video: NSObject {
    
    var thumbnail_image_name: String?
    var title: String?
    var numberOfViews: NSNumber?
    var uploadDate: NSDate?
    
    var channel: Channel?
    
    var num_likes: NSNumber?
    
}

class Channel: NSObject {
    
    var name: String?
    var profile_image_name: String?
    
}

```

```swift
func fetchFeedForUrlString(urlString: String, completion: @escaping([Video]) -> ()) {
        let url: URL? = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            do {
                /* Mutable Containers -> 바뀔 수 있는 데이터를 암시함. */
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                var videos = [Video]()
                //dictionary 형식으로 가져온다. 마치 SwiftyJson과 비슷함.
                for dictionary in json as! [[String: AnyObject]] {
                    let video = Video()
//                    video.title = dictionary["title"] as? String
//                    video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
//                    video.numberOfViews = dictionary["number_of_views"] as? NSNumber
                    
                    /* Use set values, model을 통해서 자동으로 mapping 시켜준다. */
                    video.setValuesForKeys(dictionary)
                    
                    let channelDictionary = dictionary["channel"] as! [String: AnyObject]
                    let channel = Channel()
                                        /*** 아래 주석처리된 데이터들을 자동으로 mapping 시켜준다. ***/
                    channel.setValuesForKeys(channelDictionary)
//                    channel.name = channelDictionary["name"] as? String
//                    channel.profileImagename = channelDictionary["profile_image_name"] as? String
//                    video.channel = channel
                    videos.append(video)
                }
                DispatchQueue.main.async {
                    completion(videos)
                }
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }
```

❗️ `setValuesForKeys`  를 쓰려면 모든 데이터가 있어야한다. 예를들어 rest API를 통해서 데이터를 가져온다고 했을 때, 들어오는 모든 데이터가 model에 정의되어 있어야한다.

⇒ 반드시 서버에서 들어오는 key:value 의 이름이 같아야한다.

⇒ 반드시 `NSObject`  를 상속받아야 한다.

⇒ Old fashioned way임. swift5에서 계속 에러가 나고 있다.

⇒ Swift5 에서는 안씀. Codable, Decodable, Encodable로 대체됨.

- Advanced Model

```swift
//
//  Video.swift
//  Swift Youtube App Programmatically
//
//  Created by shin seunghyun on 2020/07/06.
//

import UIKit

class Video: NSObject {
    
    var thumbnail_image_name: String?
    var title: String?
    var number_of_views: NSNumber?
//    var uploadDate: NSDate?
    var duration: NSNumber?
    
    var channel: Channel?
    
    
//    var num_likes: NSNumber?
    
    //아래 코드 block은 아 ~ 그냥 이런게 있구나 정도로 보면 된다. 실제로 swift5는 NSObject보다는 Codable, Decodable, Encodable을 사용한다.
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "channel" {
            //custom channel setup
            let channelDictionary = value as! [String: AnyObject]
            self.channel = Channel()
            self.channel?.setValuesForKeys(channelDictionary)
            
        } else {
            super.setValue(value, forKey: key)
        }
        
    }
    
    override init() {
    
    }
    
    //아래 코드 block은 아 ~ 그냥 이런게 있구나 정도로 보면 된다. 실제로 swift5는 NSObject보다는 Codable, Decodable, Encodable을 사용한다.
    init(dictionary: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dictionary)
    }
    
}

class Channel: NSObject {
    
    var name: String?
    var profile_image_name: String?
    
}
```

### Network, API Service, Refactoring for safety

```swift
func fetchFeedForUrlString(urlString: String, completion: @escaping([Video]) -> ()) {
    let url: URL? = URL(string: urlString)
    URLSession.shared.dataTask(with: url!) { (data, response, error) in
        
        print("requesting data to url: \(url!)")
        if error != nil {
            print(error!.localizedDescription)
            return
        }
                    
        do {
         
            if let unwrappedData = data {
                /* Mutable Containers -> 바뀔 수 있는 데이터를 암시함. */
                if let jsonDictoinaries = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? [[String: Any]] {
                    var videos = [Video]()
                    //dictionary 형식으로 가져온다. 마치 SwiftyJson과 비슷함.
                    for dictionary in jsonDictoinaries {
                        let video = Video()
                        video.title = dictionary["title"] as? String
                        video.thumbnail_image_name = dictionary["thumbnail_image_name"] as? String
                        video.number_of_views = dictionary["number_of_views"] as? NSNumber

                        /* Use set values, model을 통해서 자동으로 mapping 시켜준다. */
    //                    video.setValuesForKeys(dictionary)
                        
                        print("dictionary: \(dictionary)")

                        let channelDictionary = dictionary["channel"] as! [String: AnyObject]
                        let channel = Channel()
    //                    channel.setValuesForKeys(channelDictionary)
                        channel.name = channelDictionary["name"] as? String
                        channel.profile_image_name = channelDictionary["profile_image_name"] as? String
                        video.channel = channel
                        videos.append(video)
                    }
                    DispatchQueue.main.async {
                        completion(videos)
                    }
                }
            }
            

        } catch let jsonError {
            print(jsonError)
        }
    }.resume()
}
```

**ℹ️  How to use map**

```swift
let numbersArray = [1, 2, 3]
let doubledNumberArray = numbersArray.map({return $0 * 2})
let stringsArray = numbersArray.map({return "\($0 * 2)"})
```

# Lecture 16

[https://www.youtube.com/watch?v=NpG8iaM0Sfs&list=PL0dzCUj1L5JGKdVUtA5xds1zcyzsz7HLj&index=16](https://www.youtube.com/watch?v=NpG8iaM0Sfs&list=PL0dzCUj1L5JGKdVUtA5xds1zcyzsz7HLj&index=16)

### Video Launcher

```swift
//
//  VideoLauncher.swift
//  Swift Youtube App Programmatically
//
//  Created by shin seunghyun on 2020/07/10.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        backgroundColor = .black
        
        let urlString = "https://www.radiantmediaplayer.com/media/big-buck-bunny-360p.mp4"
        if let url = URL(string: urlString) {
            let player = AVPlayer(url: url)
            
            //Set Player Layer, playerLayer를 설정해주지 않으면, 절대 재생되지 않는다.
            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = self.frame
            
            player.play()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class VideoLauncher: NSObject {
    
    func showVideoPlayer() {
        print("Showing Video Player animation...")
        
        guard let window = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
        else {
            return
        }
        
        let view = UIView(frame: window.frame)
        view.backgroundColor = UIColor.white
        view.frame = CGRect(x: window.frame.width - 10, y: window.frame.height - 10, width: 10, height: 10) //모서리 부분에 작은 크기로 넣기
        
        /* Initialize Video Playerview and add it onto VideoLauncherView */
        //16 x 9 is the aspect ratio of all HD videos
        let height = window.frame.width * 9 / 16 // 9:16 비율
        let videoPlayerFrame = CGRect(x: 0, y: 0, width: window.frame.width, height: height)
        let videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
        view.addSubview(videoPlayerView)
        
        window.addSubview(view)
        
        //animation이 보여주면서 화면 전체를 cover한다.
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            view.frame = window.frame
        }) { (completedAnimation) in
            //maybe we'll do something here later...
            UIApplication.shared.setStatusBarHidden(true, with: .fade) //this method is deprecated however, it will persist for a longe time.
        }
        
        
        
    }
    
}
```

### How to use it

```swift
let videoLauncher = VideoLauncher()
videoLauncher.showVideoPlayer()
```
# Lecture 17

[https://www.youtube.com/watch?v=u1DoR5-76Xc&list=PL0dzCUj1L5JGKdVUtA5xds1zcyzsz7HLj&index=17](https://www.youtube.com/watch?v=u1DoR5-76Xc&list=PL0dzCUj1L5JGKdVUtA5xds1zcyzsz7HLj&index=17)

**ℹ️  UIApplication.shared**

- 보통 위의 api를 사용하면, warning이 나오는데 ios9부터 나옴. 즉, 써도 됨.

### Create UIActivityIndicator

```swift
//activityIndicatorView
let activityIndicatorView: UIActivityIndicatorView = {
    let aiv = UIActivityIndicatorView(style: .large)
    aiv.translatesAutoresizingMaskIntoConstraints = false
    aiv.startAnimating()
    return aiv
}()
```

### Button Toggle Clean Logic

```swift
//Clean Logic
    @objc func handlePause() {
        if isPlaying {
            player?.pause()
            pausePlayButton.setImage(UIImage(systemName: "play"), for: .normal)
        } else {
            player?.play()
            pausePlayButton.setImage(UIImage(systemName: "pause"), for: .normal)
        }
        isPlaying = !isPlaying
    }
```

# VideoLauncher

```swift
//
//  VideoLauncher.swift
//  Swift Youtube App Programmatically
//
//  Created by shin seunghyun on 2020/07/10.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    //video Container 안에 들어감
    //activityIndicatorView
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    //video Container 안에 들어감
    lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "pause")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        //button is hidden by default
        button.isHidden = true
        
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        return button
    }()
    
    var isPlaying: Bool = false
    
    //video player button등을 담아줄 frame.
    let controlsContainerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()
    
    //Clean Logic
    @objc func handlePause() {
        if isPlaying {
            player?.pause()
            pausePlayButton.setImage(UIImage(systemName: "play"), for: .normal)
        } else {
            player?.play()
            pausePlayButton.setImage(UIImage(systemName: "pause"), for: .normal)
        }
        isPlaying = !isPlaying
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //set up video view
        setupPlayerView()
        
        //set up container frame
        //video player button등을 담아줄 frame
        controlsContainerView.frame = self.frame
        self.addSubview(controlsContainerView)
        //set up activityIndicatorView
        controlsContainerView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        controlsContainerView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.backgroundColor = .black
    }
    
    var player: AVPlayer?
    
    private func setupPlayerView() {
        let urlString = "https://www.radiantmediaplayer.com/media/big-buck-bunny-360p.mp4"
        if let url = URL(string: urlString) {
            player = AVPlayer(url: url)
            
            //Set Player Layer, playerLayer를 설정해주지 않으면, 절대 재생되지 않는다.
            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = self.frame
            
            player?.play()
            
            /* Play가 시작됬는지 안됬는지 확인하기 */
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //This is when the player is ready and rendering frames
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            controlsContainerView.backgroundColor = .clear
            pausePlayButton.isHidden = false //시작되면 버튼을 다시 보여주게 한다.
            isPlaying = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class VideoLauncher: NSObject {
    
    func showVideoPlayer() {
        print("Showing Video Player animation...")
        
        guard let window = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
        else {
            return
        }
        
        let view = UIView(frame: window.frame)
        view.backgroundColor = UIColor.white
        view.frame = CGRect(x: window.frame.width - 10, y: window.frame.height - 10, width: 10, height: 10) //모서리 부분에 작은 크기로 넣기
        
        /* Initialize Video Playerview and add it onto VideoLauncherView */
        //16 x 9 is the aspect ratio of all HD videos
        let height = window.frame.width * 9 / 16 // 9:16 비율
        let videoPlayerFrame = CGRect(x: 0, y: 0, width: window.frame.width, height: height)
        let videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
        view.addSubview(videoPlayerView)
        
        window.addSubview(view)
        
        //animation이 보여주면서 화면 전체를 cover한다.
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            view.frame = window.frame
        }) { (completedAnimation) in
            //maybe we'll do something here later...
            UIApplication.shared.setStatusBarHidden(true, with: .fade) //this method is deprecated however, it will persist for a longe time.
        }
        
    }
    
}
```
