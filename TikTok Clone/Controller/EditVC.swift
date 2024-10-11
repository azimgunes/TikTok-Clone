//
//  EditVC.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 11.10.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class EditVC: UIViewController {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var signOutButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupView()
        observeData()
        overrideUserInterfaceStyle = .light
        
        
    }
    func setupView(){
        profileImage.layer.cornerRadius = 50
        signOutButton.layer.cornerRadius = 35/2
        profileImage.contentMode = .scaleAspectFill
        
    }
    func observeData(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Api.User.observeUser(withId: uid) { user in
            self.usernameTextField.text = user.username
            self.profileImage.loadImage(user.profileImageUrl)
        }
        
    }
    @IBAction func signOutButton(_ sender: Any) {
        Api.User.logOut()

    }
    
    
    @IBAction func deleteAccountButton(_ sender: Any) {
        
        
        Api.User.deleteAccount()
        Api.User.logOut()
        
        
    }
    
    @IBAction func saveButton(_ sender: Any) {
        var dict = Dictionary<String, Any>()
        if let username = usernameTextField.text, !username.isEmpty {
            dict["username"] = username
        }
        Api.User.saveUserProfile(dict: dict) {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            self.navigationController?.pushViewController(profileVC, animated: true)
        } onErr: { errorMessage in
            print("Error: \(errorMessage)")
        }
        
    }
    
}
