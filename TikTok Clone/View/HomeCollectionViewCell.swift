//
//  HomeCollectionViewCell.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 19.09.2024.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postVideo: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    var content: Content? {
        didSet {
            updateView()
        }
    }
    var user: User? {
        didSet {
            setupUserInfo()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        avatar.layer.cornerRadius = 55/2
        
    }
    func updateView(){
        descriptionLabel.text = content?.description
        
    }
    func setupUserInfo(){
        usernameLabel.text = user?.username
        guard let profileImageUrl = user?.profileImageUrl else {return}
        avatar.loadImage(profileImageUrl)
    }
}
