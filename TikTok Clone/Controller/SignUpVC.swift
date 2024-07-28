//
//  SignUpVC.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 23.07.2024.
//

import UIKit
import FirebaseAuth


class SignUpVC: UIViewController {
    
    
    //MARK: Proporties
    		

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var usernameContainer: UIView!
    @IBOutlet weak var emailContainer: UIView!
    @IBOutlet weak var passwordContainer: UIView!
    
    //MARK: Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        setupView()
        usernameTextFieldFunc()
        emailTextFieldFunc()
        passwordTextFieldFunc()
    }
    
    func setupView(){
        
        signUpButton.layer.cornerRadius = 15
    }
    
    
    
    @IBAction func signUp(_ sender: UIButton) {
        Auth.auth().createUser(withEmail: "gunes2@gmail.com", password: "123456") { result, error in
            if error != nil {
                print("ERROR: \(error!.localizedDescription)")
                return
            } else{
                if let authData = result {
                    print("USER: \(authData.user.email!)")
                }
            }
        }
   
    }
    
    
    
    
}

//MARK: Helpers

extension SignUpVC {
    
    func usernameTextFieldFunc(){
        usernameContainer.layer.borderWidth = 0.8
        usernameContainer.layer.cornerRadius = 10
        usernameContainer.layer.borderColor =  #colorLiteral(red: 0.1846590936, green: 0.1846590936, blue: 0.1846590936, alpha: 0.4318863825)
        usernameContainer.clipsToBounds = true
        usernameTextField.borderStyle = .none
        
    }
    func emailTextFieldFunc(){
        emailContainer.layer.borderWidth = 0.8
        emailContainer.layer.cornerRadius = 10
        emailContainer.layer.borderColor =   #colorLiteral(red: 0.1846590936, green: 0.1846590936, blue: 0.1846590936, alpha: 0.4318863825)
        emailContainer.clipsToBounds = true
        emailTextField.borderStyle = .none
        
    }
    func passwordTextFieldFunc(){
        passwordContainer.layer.borderWidth = 0.8
        passwordContainer.layer.cornerRadius = 10
        passwordContainer.layer.borderColor =   #colorLiteral(red: 0.1846590936, green: 0.1846590936, blue: 0.1846590936, alpha: 0.4318863825)
        passwordContainer.clipsToBounds = true
        passwordTextField.borderStyle = .none
        
    }
    
}
