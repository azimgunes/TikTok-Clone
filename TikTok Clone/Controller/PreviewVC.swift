//
//  PreviewVC.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 24.08.2024.
//

import UIKit
import AVKit

class PreviewVC: UIViewController {
    
    //MARK: Properties/Outlets
    
    @IBOutlet weak var nextButtonTapped: UIButton!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    
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
    
    
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadRecordedClips()
        startPlayFirstClip()
        setupTapGesture()
        
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
        stopVideo()
    }
    
    deinit {
        print("PreviewVC was deinitialized")
        viewWillDenitRestartVideo?()
        stopVideo()
    }
    
    init?(coder: NSCoder, recordedClips: [Videos]) {
        guard let firstClip = recordedClips.first else {
            return nil
        }
        self.currentPlayingVideo = firstClip
        self.recordedClips = recordedClips
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup Methods
    func setupView(){
        nextButtonTapped.layer.cornerRadius = 2
        nextButtonTapped.backgroundColor = UIColor(red: 254/255, green: 44/255, blue: 88/255, alpha: 1.0)
        overrideUserInterfaceStyle = .light
        
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsideVideo(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    // MARK: - Video Player Setup
    
    
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
    
    
    func loadRecordedClips() {
        recordedClips.forEach { clip in
            urlForVid.append(clip.videoUrl)
        }
    }
    
    func startPlayFirstClip(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            guard let firstClip = self.recordedClips.first else {return}
            self.currentPlayingVideo = firstClip
            self.setupPlayerView(with: firstClip)
            
        }
    }
    
    // MARK: - Video Playback End
    
    func removePeriodicTimeObserver(){
        player.replaceCurrentItem(with: nil)
        playerLayer.removeFromSuperlayer()
        
    }
    
    // MARK: - Stop Video
    
    func stopVideo() {
        player.pause()
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
    
    
    @objc func handleTapOutsideVideo(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: self.view)
        
        if !thumbImageView.frame.contains(tapLocation) {
            stopVideo()
        }
    }
    
    
    
    //MARK: Camera
    
    func mirrorPlayer(cameraPosition: AVCaptureDevice.Position){
        if cameraPosition == .front {
            thumbImageView.transform = CGAffineTransform(scaleX: -1, y: -1)
        } else {
            thumbImageView.transform = .identity
        }
        
    }
    
    //MARK: Button Actions
    
    @IBAction func cancelButton(_ sender: UIButton) {
        hideStatusBar = true
        stopVideo()
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func nextButton(_ sender: UIButton) {
        mergeClips()
        hideStatusBar = false
        stopVideo()
        
        let shareVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "ShareVC", creator: { coder -> ShareVC? in
            ShareVC(coder: coder, videoUrl: self.currentPlayingVideo.videoUrl)
        })
        shareVC.selectedPhoto = thumbImageView.image
        navigationController?.pushViewController(shareVC, animated: true)
        return
    }
    
    //MARK: Merging
    
    func mergeClips(){
        VideoCompisitionWriter().mergeMultiVideo(urls: urlForVid) { success, outputURL in
            if success {
                guard let outputURLunwrapped = outputURL else {return}
                print("outputURLUnwrapped", outputURLunwrapped)
                
                DispatchQueue.main.async {
                    let player = AVPlayer(url: outputURLunwrapped)
                    let vc = AVPlayerViewController()
                    vc.player = player
                    
                    self.present(vc, animated: true) {
                        vc.player?.play()
                    }
                }
            }
        }
    }
    
}


