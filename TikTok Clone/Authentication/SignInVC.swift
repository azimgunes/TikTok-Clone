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
    
    
    //MARK: Properties/Outlets
    
    
    @IBOutlet weak var signBackground: UIImageView!
    
    @IBOutlet weak var emailContainer: UIView!
    
    @IBOutlet weak var passwordContainer: UIView!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var signInButton: UIButton!
    
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        hideKeyboard()
        setupView()
        emailTextFieldFunc()
        passwordTextFieldFunc()
        
        
        
        
    }
    
    //MARK: Actions
    
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
    
    @IBAction func registerButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "toSignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


extension SignInVC {
    //MARK: DATA Function
    
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
    
    //MARK: Controls
    
    
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
    
    //MARK: Helpers
    
    
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
    
    //MARK: Actions
    
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
    
    //MARK: Setup Methods
    
    func setupView(){
        signInButton.layer.cornerRadius = 10
        
        signBackground.clipsToBounds = true
        signBackground.contentMode = .scaleAspectFill
        signBackground.layer.cornerRadius = 100
        signBackground.layer.maskedCorners = [.layerMinXMaxYCorner]
        view.addSubview(signBackground)
        
        signBackground.layer.zPosition = -1
        
    }
    
}
