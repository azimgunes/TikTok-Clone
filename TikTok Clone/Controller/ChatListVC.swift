//
//  ChatListVC.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 9.11.2024.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class ChatListVC: UIViewController {
    
    //MARK: Properties/Outlets
    
    
    @IBOutlet weak var tableView: UITableView!
    var users = [ChatUser]()
    
    //MARK: Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchUsers()
        vcSettings()
    }
    
    
    //MARK: Setup Methods
    
    func setupView(){
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
    }
    
    //MARK: Data & Service
    
    
    func fetchUsers() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("messages")
            .whereField("senderID", isEqualTo: currentUserID)
            .addSnapshotListener { senderSnapshot, error in
                guard let senderDocs = senderSnapshot?.documents, error == nil else { return }
                
                var usersWithMessages = Set<String>()
                
                for document in senderDocs {
                    let data = document.data()
                    if let receiverID = data["receiverID"] as? String {
                        usersWithMessages.insert(receiverID)
                    }
                }
                
                db.collection("messages")
                    .whereField("receiverID", isEqualTo: currentUserID)
                    .addSnapshotListener { receiverSnapshot, error in
                        guard let receiverDocs = receiverSnapshot?.documents, error == nil else { return }
                        
                        for document in receiverDocs {
                            let data = document.data()
                            if let senderID = data["senderID"] as? String {
                                usersWithMessages.insert(senderID)
                            }
                        }
                        
                        usersWithMessages.remove(currentUserID)
                        
                        db.collection("users")
                            .whereField("uid", in: Array(usersWithMessages))
                            .getDocuments { (snapshot, error) in
                                guard let documents = snapshot?.documents, error == nil else { return }
                                
                                self.users = []
                                
                                for document in documents {
                                    let data = document.data()
                                    let user = ChatUser(
                                        uid: data["uid"] as! String,
                                        username: data["username"] as! String,
                                        profileImageUrl: data["profileImageUrl"] as? String ?? ""
                                    )
                                    self.users.append(user)
                                }
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                            }
                    }
            }
    }
    
}

//MARK: UITableViewDelegate, UITableViewDataSource


extension ChatListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCell", for: indexPath) as! ChatListCell
        let user = users[indexPath.row]
        cell.usernameLabel?.text = user.username
        let url = URL(string: user.profileImageUrl)
        cell.profileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "default option"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = users[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let chatVC = storyboard.instantiateViewController(withIdentifier: "ChatVC") as? ChatVC {
            chatVC.selectedUser = selectedUser
            navigationController?.pushViewController(chatVC, animated: true)
        }
    }
}
