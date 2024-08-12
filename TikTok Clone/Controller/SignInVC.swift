//
//  SignInVC.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 24.07.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI

class SignInVC: UIViewController {
    
    
    //MARK: Proporties
    
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var emailContainer: UIView!
    
    @IBOutlet weak var passwordContainer: UIView!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var signInButton: UIButton!
    
 
    //MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        emailTextFieldFunc()
        passwordTextFieldFunc()

    }

    
    @IBAction func signInTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        self.validateFields()
        self.signIn {
            let scene = UIApplication.shared.connectedScenes.first
            if let sceneDelegate : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                sceneDelegate.configInitialVC()
            }
        } onErr: { errorMesssage in
            print("ERROR \(errorMesssage)")
        }

    }

}


extension SignInVC {
    
    func signIn(onSuc: @escaping() -> Void, onErr: @escaping(_ errorMesssage: String) -> Void){
        Api.User.signIn(email: self.emailTextField.text!, password: self.passwordTextField.text!) {
            let scene = UIApplication.shared.connectedScenes.first
            if let sceneDelegate : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                sceneDelegate.configInitialVC()
            }        } onErr: { errorMesssage in
            self.alertSigningFunc()
            print(errorMesssage)
           
        }

    }
    
    func validateFields(){
        guard let email = self.emailTextField.text, !email.isEmpty else {
            alertFunc()
            return
        }
        guard let password = self.passwordTextField.text, !password.isEmpty else {
            alertFunc()
            return
        }
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
    func alertFunc(){
        let alert = UIAlertController(title: "Error!", message: "Make sure you fill in the blank fields and try again.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Try Again!", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertSigningFunc(){
        let alert = UIAlertController(title: "Error!", message: "Check your email or password.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Try Again!", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func setupView(){
        signInButton.layer.cornerRadius = 10
  
    }
    
}
