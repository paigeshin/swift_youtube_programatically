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
    
    /* 1. Video Slider: Create UILabel */
    let videoLengthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    
    /* 3. Video Slider: Create UISlider */
    let videoSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .white
//        slider.setThumbImage(UIImage(systemName: "circle"), for: .normal)
        slider.addTarget(self, action: #selector(handleSliderChange), for: .touchUpInside)
        return slider
    }()
    
    /* 6. Video Slider: Handle slider change event */
    @objc func handleSliderChange() {
        print(videoSlider.value)
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(videoSlider.value) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            player?.seek(to: seekTime, completionHandler: { (completedSeek) in
                
            })
        }
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
    
        /* 2. Video Slider: add videoLengthLabel to controlContainerView */
        controlsContainerView.addSubview(videoLengthLabel)
        videoLengthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        /* 4. Video Slider, add slider to controlContainerView */
        controlsContainerView.addSubview(videoSlider)
        videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor).isActive = true
        videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        backgroundColor = .black
    
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
            
            /* 5. Video Slider: Change Actual Value */
            if let duration = player?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                let secondsText = Int(seconds) % 60
                let minutesText = String(format: "%02d", Int(seconds) / 60)
                videoLengthLabel.text = "\(minutesText):\(secondsText)"
            }
            
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
