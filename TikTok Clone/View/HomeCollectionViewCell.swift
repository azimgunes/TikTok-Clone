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
    

    override func awakeFromNib() {
        super.awakeFromNib()
        avatar.layer.cornerRadius = 55/2
  

    }

}
