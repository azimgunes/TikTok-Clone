//
//  ChatVC.swift
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


    @IBOutlet weak var tableView: UITableView!

    
    
    var users = [ChatUser]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tabBarController?.tabBar.barTintColor =  .white
        tabBarController?.tabBar.tintColor = .black
        tabBarController?.tabBar.backgroundColor = .white
        

        
                
                fetchUsers()
    }
    func fetchUsers() {
        let db = Firestore.firestore()
        db.collection("users").getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents, error == nil else { return }
            
            for document in documents {
                let data = document.data()
                let user = ChatUser(
                    uid: data["uid"] as! String,
                    username: data["username"] as! String,
                    profileImageUrl: data["profileImageUrl"] as? String ?? ""
                )
                self.users.append(user)
            }
            self.tableView.reloadData()
        }
    }


}

extension ChatListVC: UITableViewDataSource, UITableViewDelegate {
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
