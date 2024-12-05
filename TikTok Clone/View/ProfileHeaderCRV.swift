//
//  ProfileHeaderCRV.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 25.09.2024.
//

import UIKit

class ProfileHeaderCRV: UICollectionReusableView {
    
    //MARK: Properties/Outlets
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var collectButton: UIButton!
    
    var user: User?{
        didSet{
            updateView()
        }
    }
    
    //MARK: Setup Methods 
    
    func setupView(){
        profileImage.layer.cornerRadius = 50
        profileImage.layer.borderWidth = 0.8
        profileImage.layer.borderColor = UIColor.lightGray.cgColor
        editButton.layer.borderColor = UIColor.lightGray.cgColor
        editButton.layer.borderWidth = 0.8
        editButton.layer.cornerRadius = 5
        collectButton.layer.borderColor = UIColor.lightGray.cgColor
        collectButton.layer.borderWidth = 0.8
        collectButton.layer.cornerRadius = 5
    }
    
    func updateView(){
        self.usernameLabel.text = user!.username!
        guard let profileImageUrl = user!.profileImageUrl else {return}
        self.profileImage.loadImage(profileImageUrl)
        
    }
}
