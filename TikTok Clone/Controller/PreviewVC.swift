//
//  PreviewVC.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 24.08.2024.
//

import UIKit
import AVKit

class PreviewVC: UIViewController {
    
    //MARK: Proporties
    
    var currentPlayingVideo: Videos
    var recordedClips: [Videos] = []
    var viewWillDenitRestartVideo: (() -> Void)?
    var player: AVPlayer = AVPlayer()
    var playerLayer: AVPlayerLayer = AVPlayerLayer()
    var urlForVid: [URL] = [] {
        didSet {
            print("outputUrlunWrapped:", urlForVid)
        }
    }
    
    var hideStatusBar: Bool = true {
        didSet {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    @IBOutlet weak var thumbImageView: UIImageView!
    
    
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        startPlayFirstClip()
        hideStatusBar = true
        recordedClips.forEach { clip in
            urlForVid.append(clip.videoUrl)
        }
        print("\(recordedClips.count)")

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBarAndNavigationBar()
        player.play()
        hideStatusBar = true
   
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBarAndNavigationBar()
        player.pause()
        
       
    }
    
    deinit {
        print("PreviewVC was deineted")
        (viewWillDenitRestartVideo)?()
    }
    
    init?(coder: NSCoder, recordedClips: [Videos]){
        self.currentPlayingVideo = recordedClips.first!
        self.recordedClips = recordedClips
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func startPlayFirstClip(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            guard let firstClip = self.recordedClips.first else {return}
            self.currentPlayingVideo = firstClip
            self.setupPlayerView(with: firstClip)
            
        }
    }
    
    func setupPlayerView(with videoClip: Videos) {
        let player = AVPlayer(url: videoClip.videoUrl)
        let playerLayer = AVPlayerLayer(player: player)
        self.player = player
        self.playerLayer = playerLayer
        playerLayer.frame = thumbImageView.frame
        self.player = player
        self.playerLayer = playerLayer
        thumbImageView.layer.insertSublayer(playerLayer, at: 3)
        player.play()
        
        NotificationCenter.default.addObserver(self, selector: #selector(avPlayerItemDidPlayToEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        mirrorPlayer(cameraPosition: videoClip.cameraPosition)
    }
    func removePeriodicTimeObserver(){
        player.replaceCurrentItem(with: nil)
        playerLayer.removeFromSuperlayer()
    }
    @objc func avPlayerItemDidPlayToEndTime(notification: Notification){
        if let currentIndex = recordedClips.firstIndex(of: currentPlayingVideo) {
            let nextIndex = currentIndex + 1
            if nextIndex > recordedClips.count - 1 {
                removePeriodicTimeObserver()
                guard let firstClip = recordedClips.first else {return}
                setupPlayerView(with: firstClip)
                currentPlayingVideo = firstClip
            } else {
                for (index, clip) in recordedClips.enumerated() {
                    if index == nextIndex {
                        removePeriodicTimeObserver()
                        setupPlayerView(with: clip)
                        currentPlayingVideo = clip
                    }
                }
            }
        }
    }
    

    func mirrorPlayer(cameraPosition: AVCaptureDevice.Position){
        if cameraPosition == .front {
            thumbImageView.transform = CGAffineTransform(scaleX: -1, y: -1)
        } else {
            thumbImageView.transform = .identity
        }
        
    }
    @IBAction func cancelButton(_ sender: UIButton) {
    }
}


extension PreviewVC {
    // MARK: - Helper Methods
    private func hideTabBarAndNavigationBar() {
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func showTabBarAndNavigationBar() {
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
