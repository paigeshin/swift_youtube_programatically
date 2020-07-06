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
