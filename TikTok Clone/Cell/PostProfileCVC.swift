//
//  PostProfileCVC.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 25.09.2024.
//

import UIKit


protocol PostProfileCVCDelegate {
    func toDetailVC(postId: String)
}


class PostProfileCVC: UICollectionViewCell {
    
    var delegate: PostProfileCVCDelegate?
    
    @IBOutlet weak var imageView: UIImageView!
    
    var post: Post? {
        didSet{
            updateView()
        }
    }
    
    
    
    func updateView(){
        guard let postThumbımage = post?.imageUrl else {return}
        
        
        self.imageView.loadImage(postThumbımage)
        
        let tapGestureForPhoto = UITapGestureRecognizer(target: self, action: #selector(toDetail))
        imageView.addGestureRecognizer(tapGestureForPhoto)
        imageView.isUserInteractionEnabled = true
        
        print("update view is working")
        
        
    }
    
    
    
    @objc func toDetail(){
        if let id = post?.postId {
            delegate?.toDetailVC(postId: id)
            
            
            print("ImageView clicked")
            print("selected postId: \(id)")
        }
    }
}
