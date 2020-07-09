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
       
        /* iOS 13 미만 */
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.makeKeyAndVisible()
        /**
         This is a convenience method to show the current window and position it in front of all other windows at the same level or lower. If you only want to show the window, change its isHidden property to false.
         **/
        
        
        let layout = UICollectionViewFlowLayout()
        /* collectionView scroll Direction 적용해주기 */
//        layout.scrollDirection = .horizontal
        window?.rootViewController = UINavigationController(rootViewController: HomeController(collectionViewLayout: layout))
        
        /* Navigation Controller Design */
        
        // get rid of black bar underneath navbar
        UINavigationBar.appearance().barTintColor = UIColor.rgb(red: 230, green: 32, blue: 31)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        
        /* 아래 코드 작동하지 않음.. */
        //statusBar끝만 덮어씌우기 방식으로 색깔 바꿔주기
//        let statusBarBackgroundView = UIView()
//        statusBarBackgroundView.backgroundColor = UIColor.rgb(red: 194, green: 31, blue: 31)
//        window?.addSubview(statusBarBackgroundView)
//        window?.addConstraintsWithFormat(format: "H:|[v0]|", views: statusBarBackgroundView)
        //swift format language에서 V:|[v0(20)]|를 하면, 마지막 constraint 값이 0이라는 의미다.
        //swift format language에서 V:|[v0(20)]를 하면, 마지막 cosntraint 값이 없다.
//        window?.addConstraintsWithFormat(format: "V:|[v0(20)]", views: statusBarBackgroundView)
        
        //해당하는 것을 작동시키려면 Info.plist에 `View controller-based status bar appearance - NO`를 추가해줘야 한다.
        
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

