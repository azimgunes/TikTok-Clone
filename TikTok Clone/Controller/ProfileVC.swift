//
//  ProfileVC.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 12.08.2024.
//

import UIKit

class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func logOutButton(_ sender: Any) {
        Api.User.logOut()
    }
    
}
