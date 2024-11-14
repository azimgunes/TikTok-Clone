import UIKit
import SDWebImage

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var senderUsername: UILabel!
    @IBOutlet weak var senderMessage: UILabel!
    
    @IBOutlet weak var receiverUsername: UILabel!
    @IBOutlet weak var receiverMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        senderMessage.text = ""
        receiverMessage.text = ""
        senderUsername.isHidden = true
        senderMessage.isHidden = true
        receiverUsername.isHidden = true
        receiverMessage.isHidden = true
    }
    
    func configure(with message: ChatMessage, currentUserID: String, selectedUser: ChatUser) {
        if message.senderId == currentUserID {
            senderMessage.text = message.text
            senderUsername.text = "You"
            senderUsername.isHidden = false
            senderMessage.isHidden = false
            receiverUsername.isHidden = true
            receiverMessage.isHidden = true
        } else {
            receiverMessage.text = message.text
            receiverUsername.text = selectedUser.username
            receiverUsername.isHidden = false
            receiverMessage.isHidden = false
            senderUsername.isHidden = true
            senderMessage.isHidden = true
        }
    }
}
