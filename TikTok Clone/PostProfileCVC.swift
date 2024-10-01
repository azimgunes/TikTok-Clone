//
//  PostProfileCVC.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 25.09.2024.
//

import UIKit

class PostProfileCVC: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(with post: Post) {
        imageView.loadImage(post.imageUrl) 
    }
}
