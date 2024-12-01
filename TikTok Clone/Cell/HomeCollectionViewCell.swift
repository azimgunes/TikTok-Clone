//
//  HomeCollectionViewCell.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 19.09.2024.
//

import UIKit
import AVFoundation
protocol HomeCollectionViewCellDelegate{
    func toUserVC(userId: String)
}

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postVideo: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    var queuePlayer: AVQueuePlayer?
    var playerLayer: AVPlayerLayer?
    var playbackLooper: AVPlayerLooper?
    var isPlaying = false
    var delegate: HomeCollectionViewCellDelegate?
    
    
    var post : Post? {
        didSet{
            updateView()
            
        }
    }
    
    var user: User? {
        didSet {
            setupUser()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category.")
        }
        
        avatar.layer.cornerRadius = 55/2
        
        let tapGestureForImage = UITapGestureRecognizer(target: self, action: #selector(avatarTouched))
        avatar.isUserInteractionEnabled = true
        avatar.addGestureRecognizer(tapGestureForImage)
        avatar.clipsToBounds = true
    }
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerLayer?.removeFromSuperlayer()
        stopVideo()
        queuePlayer?.pause()
        queuePlayer = nil
        playbackLooper = nil
        isPlaying = false
    }
    
    @objc func avatarTouched(){
        if let id = user?.uid {
            delegate?.toUserVC(userId: id)
        }
    }
    
    func updateView(){
        descriptionLabel.text = post?.description
        
        if let videoUrlString = post?.videoUrl, let videoUrl = URL(string: videoUrlString) {
            let playerItem = AVPlayerItem(url: videoUrl)
            self.queuePlayer = AVQueuePlayer(playerItem: playerItem)
            self.playerLayer = AVPlayerLayer(player: self.queuePlayer)
            
            guard let playerLayer = self.playerLayer else {return}
            guard let queuePlayer = self.queuePlayer else {return}
            
            self .playbackLooper = AVPlayerLooper.init(player: queuePlayer, templateItem: playerItem)
            
            playerLayer.videoGravity = .resizeAspectFill
            playerLayer.frame = contentView.bounds
            
            if playerLayer.superlayer == nil {
                postVideo.layer.insertSublayer(playerLayer, at: 0)
            }
            queuePlayer.play()
        }
    }
    
    func setupUser(){
        usernameLabel.text = user?.username
        
        guard let profileImageUrl = user?.profileImageUrl else {return}
        avatar.loadImage(profileImageUrl)
    }
    
    func replayVideo(){
        if isPlaying {
            self.queuePlayer?.seek(to: .zero)
            self.queuePlayer?.play()
            playVideo()
        }
        
    }
    
    
    func playVideo(){
        if !isPlaying {
            self.queuePlayer?.play()
            isPlaying = true
        }
    }
    
    func pauseVideo(){
        if isPlaying {
            self.queuePlayer?.pause()
            isPlaying = false
        }
        
    }
    func stopVideo(){
        self.queuePlayer?.pause()
        self.queuePlayer?.seek(to: .zero)
    }
}
