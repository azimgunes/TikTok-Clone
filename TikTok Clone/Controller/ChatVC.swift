import UIKit
import FirebaseFirestore
import FirebaseAuth

class ChatVC: UIViewController {
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    
      var selectedUser: ChatUser?
      var messages = [ChatMessage]()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.dataSource = self
        chatTableView.delegate = self

   
        fetchMessages()

    }
    
    func fetchMessages() {
            guard let currentUser = Auth.auth().currentUser, let selectedUser = selectedUser else { return }
            
            let db = Firestore.firestore()
            db.collection("messages")
                .whereField("senderId", in: [currentUser.uid, selectedUser.uid])
                .whereField("receiverId", in: [currentUser.uid, selectedUser.uid])
                .order(by: "timestamp", descending: false)
                .addSnapshotListener { (snapshot, error) in
                    guard let documents = snapshot?.documents, error == nil else { return }
                    
                    self.messages.removeAll()
                    for document in documents {
                        let data = document.data()
                        let message = ChatMessage(
                            text: data["text"] as! String,
                            timestamp: (data["timestamp"] as! Timestamp).dateValue(),
                            senderId: data["senderId"] as! String,
                            receiverId: data["receiverId"] as! String
                        )
                        self.messages.append(message)
                    }
                    
                    self.chatTableView.reloadData()
                    
                    if !self.messages.isEmpty {
                        let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                        self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    }
                }
        }
        

    

    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        guard let text = messageTextField.text, !text.isEmpty,
                   let currentUser = Auth.auth().currentUser,
                   let selectedUser = selectedUser else { return }
             
             let db = Firestore.firestore()
             let newMessage = [
                 "text": text,
                 "timestamp": Timestamp(date: Date()),
                 "senderId": currentUser.uid,
                 "receiverId": selectedUser.uid
             ] as [String : Any]
             
             db.collection("messages").addDocument(data: newMessage) { error in
                 if let error = error {
                     print("Mesaj gönderilirken hata: \(error.localizedDescription)")
                 } else {
                     self.messageTextField.text = ""
                 }
             }
      }

    }


extension ChatVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        let message = messages[indexPath.row]
        
        // Mesajın göndericiye göre görselleştirilmesi
        cell.textLabel?.text = message.text
        return cell
    }
}
