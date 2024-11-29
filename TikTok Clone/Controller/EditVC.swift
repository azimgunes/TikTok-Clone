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
    
    //MARK: Properties 
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var signOutButton: UIButton!
    
    
    @IBOutlet weak var logOutButton: UIButton!
    
    
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupView()
        observeData()
        overrideUserInterfaceStyle = .light
        navigationController?.navigationBar.tintColor = .black
     
        
        
        
    }
    
    //MARK: Setup
    func setupView(){
        profileImage.layer.cornerRadius = 70
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor(#colorLiteral(red: 1, green: 0.1987546384, blue: 0.3715653121, alpha: 0.887598303)).cgColor
        signOutButton.layer.cornerRadius = 35/2
        profileImage.contentMode = .scaleAspectFill
        logOutButton.layer.cornerRadius = 15
        
    }
    
    //MARK: DATA
    func observeData(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Api.User.observeUser(withId: uid) { user in
            self.usernameTextField.text = user.username
            self.profileImage.loadImage(user.profileImageUrl)
        }
        
    }
    
    //MARK: Action Methods
    @IBAction func SaveButtonTapped(_ sender: Any) {
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
    
    
    @IBAction func deleteAccountButton(_ sender: Any) {
        
        
        Api.User.deleteAccount()
        Api.User.logOut()
        
        
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
      print("NIL!")
    }
    
    
    @IBAction func logOutButtonTapped(_ sender: UIButton) {
        Api.User.logOut()
    }
    
}
