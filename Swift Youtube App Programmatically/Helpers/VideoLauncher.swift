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
