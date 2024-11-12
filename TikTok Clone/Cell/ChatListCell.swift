//
//  MessageCell.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 9.11.2024.
//

import UIKit

class ChatListCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    @IBOutlet weak var messageLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
             profileImageView.clipsToBounds = true    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func configure(with user: ChatUser) {
         usernameLabel.text = user.username
        if let url = URL(string: user.profileImageUrl) {
             // Profil resmini asenkron olarak yükleme (örn. URLSession veya bir kütüphane kullanabilirsiniz)
             URLSession.shared.dataTask(with: url) { data, _, error in
                 guard let data = data, error == nil else { return }
                 DispatchQueue.main.async {
                     self.profileImageView.image = UIImage(data: data)
                 }
             }.resume()
         } else {
             // Varsayılan bir profil resmi eklemek isterseniz
             profileImageView.image = UIImage(named: "defaultProfileImage")
         }
     }
}
