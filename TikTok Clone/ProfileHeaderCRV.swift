//
//  ProfileHeaderCRV.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 25.09.2024.
//

import UIKit

class ProfileHeaderCRV: UICollectionReusableView {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var collectButton: UIButton!
    
    var user: User?{
        didSet{
            updateView()
        }
    }
    
    
    func setupView(){
        profileImage.layer.cornerRadius = 50
        editButton.layer.borderColor = UIColor.lightGray.cgColor
        editButton.layer.borderWidth = 0.8
        editButton.backgroundColor = .white
        editButton.layer.cornerRadius = 5
        collectButton.layer.borderColor = UIColor.lightGray.cgColor
        collectButton.layer.borderWidth = 0.8
        collectButton.backgroundColor = .white
        collectButton.layer.cornerRadius = 5
    }
    
    func updateView(){
        self.usernameLabel.text = "@" + user!.username!
        guard let profileImageUrl = user!.profileImageUrl else {return}
        self.profileImage.loadImage(profileImageUrl)
        
    }
}
