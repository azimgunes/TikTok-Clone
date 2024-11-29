//
//  ExploreTableViewCell.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 6.10.2024.
//

import UIKit

class ExploreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    var user: User? {
        didSet{
            loadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        profileImage.layer.cornerRadius = 25
        
        
    }
    
    func loadData() {
        self.usernameLabel.text = user?.username
        guard let profileImageUrl = user?.profileImageUrl else {return}
        profileImage.loadImage(profileImageUrl)
    }
}
