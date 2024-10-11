//
//  EditVC.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 11.10.2024.
//

import UIKit

class EditVC: UIViewController {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var signOutButton: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        overrideUserInterfaceStyle = .light


    }
    
    @IBAction func signOutButton(_ sender: Any) {
    }
    

    @IBAction func deleteAccountButton(_ sender: Any) {
    }
    
}
