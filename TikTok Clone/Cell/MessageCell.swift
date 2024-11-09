//
//  MessageCell.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 9.11.2024.
//

import UIKit

class MessageCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    @IBOutlet weak var messageLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
