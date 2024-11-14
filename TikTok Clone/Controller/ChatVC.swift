//
//  ChatVC.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 9.11.2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var selectedUser: ChatUser?
    var messages = [ChatMessage]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatTableView.dataSource = self
        chatTableView.delegate = self
        hideKeyboard()
        fetchMessages()

        overrideUserInterfaceStyle = .light
        
    }

    func fetchMessages() {
        guard let currentUserID = Auth.auth().currentUser?.uid,
              let selectedUserID = selectedUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("messages")
            .whereField("senderID", in: [currentUserID, selectedUserID])
            .whereField("receiverID", in: [currentUserID, selectedUserID])
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Fetching ERROR: \(error.localizedDescription)")
                    return
                }
                
                self.messages = querySnapshot?.documents.compactMap { document in
                    let data = document.data()
                    return ChatMessage(
                        text: data["text"] as? String ?? "",
                        timestamp: data["timestamp"] as? Timestamp ?? Timestamp(date: Date()),
                        senderId: data["senderID"] as? String ?? "",
                        receiverId: data["receiverID"] as? String ?? ""
                    )
                } ?? []
                
                DispatchQueue.main.async {
                    self.chatTableView.reloadData()
                    if !self.messages.isEmpty {
                        let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                        self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    }
                }
            }
    }
    
    
    
    
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        guard let text = messageTextField.text, !text.isEmpty else { return }
        guard let currentUserID = Auth.auth().currentUser?.uid,
              let selectedUserID = selectedUser?.uid else { return }
        
        let db = Firestore.firestore()
        let messageData: [String: Any] = [
            "senderID": currentUserID,
            "receiverID": selectedUserID,
            "text": text,
            "timestamp": Timestamp(date: Date())
        ]
        
        db.collection("messages").addDocument(data: messageData) { error in
            if let error = error {
                print("Sending ERROR: \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                self.messageTextField.text = ""
            }   
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageCell else {
            return UITableViewCell()
        }
        
        let message = messages[indexPath.row]
        let currentUserID = Auth.auth().currentUser?.uid ?? ""
        
        cell.configure(with: message, currentUserID: currentUserID, selectedUser: selectedUser!)
        
        return cell
    }
}
