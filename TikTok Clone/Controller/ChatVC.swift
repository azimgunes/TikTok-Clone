//
//  ChatVC.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 9.11.2024.
//

import UIKit

class ChatVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

    }
    

    @IBAction func sendButton(_ sender: UIButton) {
    }
}


extension ChatVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageCell else {
              return UITableViewCell()
          }
          
     
          
          return cell
      }
    
    
}
