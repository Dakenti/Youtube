//
//  VideoLauncher.swift
//  Youtube
//
//  Created by Dake Aga on 1/2/19.
//  Copyright © 2019 Dake Aga. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayer: UIView {
    
    var isPlaying = false
    
    var player: AVPlayer?
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "pause"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        
        button.addTarget(self, action: #selector(handlePausePlay), for: .touchUpInside)
        
        return button
    }()
    
    let contextControlView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()
    
    let videoLengthLabel: UILabel = {
        let length = UILabel()
        length.text = "00:00"
        length.font = UIFont.boldSystemFont(ofSize: 13)
        length.translatesAutoresizingMaskIntoConstraints = false
        length.textColor = .white
        length.textAlignment = .right
        return length
    }()
    
    let currentVideoTime: UILabel = {
        let ct = UILabel()
        ct.translatesAutoresizingMaskIntoConstraints = false
        ct.font = UIFont.boldSystemFont(ofSize: 13)
        ct.textColor = .white
        ct.text = "00:00"
        return ct
    }()
    
    lazy var videoSlider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .white
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
        
        slider.addTarget(self, action: #selector(handleSlidder), for: .valueChanged)
        
        return slider
    }()
    
    @objc func handleSlidder(){
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            
            let value = Float64(videoSlider.value) * totalSeconds
            
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            
            player?.seek(to: seekTime, completionHandler: { (completedSeek) in
                //perhaps do something later here
            })
        }
    }
    
    @objc func handlePausePlay(){
        if isPlaying{
            pausePlayButton.setImage(UIImage(named: "play"), for: .normal)
            player?.pause()
        } else {
            pausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
            player?.play()
        }
        
        isPlaying = !isPlaying
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupVideoPlayer()
        
        setupGradientLayer()
        
        contextControlView.frame = frame
        addSubview(contextControlView)
        
        contextControlView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        contextControlView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50)
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50)
        
        contextControlView.addSubview(videoLengthLabel)
        videoLengthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        contextControlView.addSubview(currentVideoTime)
        currentVideoTime.leftAnchor.constraint(equalTo: leftAnchor, constant: -8).isActive = true
        currentVideoTime.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        currentVideoTime.widthAnchor.constraint(equalToConstant: 50).isActive = true
        currentVideoTime.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        contextControlView.addSubview(videoSlider)
        videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: currentVideoTime.rightAnchor).isActive = true
        videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        backgroundColor = .black
    }
    
    private func setupGradientLayer(){
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.7, 1.2]
        
        contextControlView.layer.addSublayer(gradient)
    }
    
    private func setupVideoPlayer(){
        let urlString = "https://firebasestorage.googleapis.com/v0/b/server-31408.appspot.com/o/SampleVideo_1280x720_1mb.mp4?alt=media&token=6c4f3580-8209-4b4f-9ad5-5cc4beb470a3"
        if let url = URL(string: urlString) {
            player = AVPlayer(url: url)
            
            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = self.frame
            
            player?.play()
            
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            
            let interval = CMTime(value: 1, timescale: 2)
            player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
                let seconds = CMTimeGetSeconds(progressTime)
                let secondsString = String(format: "%02d", Int(seconds) % 60)
                let minutesString = String(format: "%02d", Int(seconds / 60))
                
                self.currentVideoTime.text = "\(minutesString):\(secondsString)"
                
                if let duration = self.player?.currentItem?.duration {
                    let totalSeconds = CMTimeGetSeconds(duration)
                    self.videoSlider.value = Float(seconds / totalSeconds)
                }
            })
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges"{
            activityIndicatorView.stopAnimating()
            contextControlView.backgroundColor = .clear
            pausePlayButton.isHidden = false
            isPlaying = true
            
            if let duration = player?.currentItem?.duration{
                let videoLengthInSeconds = duration.seconds
                let seconds = String(format: "%02d", Int(videoLengthInSeconds) % 60)
                let minutes = String(format: "%02d", Int(videoLengthInSeconds) / 60)
                videoLengthLabel.text = "\(minutes):\(seconds)"
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VideoLauncher: NSObject {
    func showVideoPlayer(){
        print("Showing Video Player ... ")
        
        if let keyWindow = UIApplication.shared.keyWindow {
            
            let view = UIView(frame: CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10))
            view.backgroundColor = .white
            
            // first of all you HAVE TO SET the frame of view in CLASS(VideoPlayer) FRAME
            
            let height = keyWindow.frame.width * 9 / 16
            let videoPlayerFrame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            let videoPlayerView = VideoPlayer(frame: videoPlayerFrame)
            view.addSubview(videoPlayerView)
            
            keyWindow.addSubview(view)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                view.frame = keyWindow.frame
            }) { (_) in
                let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
                statusBar.isHidden = true            }
        }
    }
}
