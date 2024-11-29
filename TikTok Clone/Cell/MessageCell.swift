import UIKit
import SDWebImage

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var senderUsername: UILabel!
    @IBOutlet weak var senderMessage: UILabel!
    
    @IBOutlet weak var receiverUsername: UILabel!
    @IBOutlet weak var receiverMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        senderMessage.text = ""
        receiverMessage.text = ""
        senderUsername.isHidden = true
        senderMessage.isHidden = true
        receiverUsername.isHidden = true
        receiverMessage.isHidden = true
        
        receiverMessage.numberOfLines = 0
        receiverUsername.numberOfLines = 0
        senderMessage.numberOfLines = 0
        senderUsername.numberOfLines = 0
    }
    
    func configure(with message: ChatMessage, currentUserID: String, selectedUser: ChatUser) {
        if message.senderId == currentUserID {
            senderMessage.text = "  " + message.text + "   "
            senderUsername.text = " " + "You" +  " "
            senderUsername.isHidden = false
            senderMessage.isHidden = false
            senderMessage.sizeToFit()
            self.setNeedsLayout()
            self.layoutIfNeeded()
            
            
            receiverUsername.isHidden = true
            receiverMessage.isHidden = true
        } else {
            receiverMessage.text = "    " + message.text + "        "
            receiverUsername.text = "    " + selectedUser.username + "    "
            receiverUsername.isHidden = false
            receiverMessage.isHidden = false
            receiverMessage.sizeToFit()
            self.setNeedsLayout()
            self.layoutIfNeeded()
            senderUsername.isHidden = true
            senderMessage.isHidden = true
        }
    }
    
    func setupCell(){
        receiverMessage.layer.borderColor = UIColor.systemBlue.cgColor
        receiverMessage.layer.borderWidth = 0.2
        receiverMessage.adjustsFontSizeToFitWidth = true
        receiverMessage.layer.cornerRadius = 7
        receiverMessage.layer.masksToBounds = true
        
        senderMessage.layer.borderColor = UIColor.red.cgColor
        senderMessage.layer.borderWidth = 0.2
        senderMessage.adjustsFontSizeToFitWidth = true
        senderMessage.layer.cornerRadius = 7
        senderMessage.layer.masksToBounds = true
        
        
        receiverUsername.clipsToBounds = true
        receiverUsername.layer.masksToBounds = true
        receiverUsername.layer.cornerRadius = 7
        
        senderUsername.clipsToBounds = true
        senderUsername.layer.masksToBounds = true
        senderUsername.layer.cornerRadius = 7
    }
    
}
