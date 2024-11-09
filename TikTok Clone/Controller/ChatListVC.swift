//
//  ChatVC.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 9.11.2024.
//

import UIKit

class ChatListVC: UIViewController {


    @IBOutlet weak var tableView: UITableView!

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tabBarController?.tabBar.barTintColor =  .white
        tabBarController?.tabBar.tintColor = .black
        tabBarController?.tabBar.backgroundColor = .white
    }
    

    @IBAction func sendButton(_ sender: UIButton) {
    }
}


extension ChatListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCell", for: indexPath) as? ChatListCell else {
              return UITableViewCell()
          }
          
     
          
          return cell
      }
    
    
}
