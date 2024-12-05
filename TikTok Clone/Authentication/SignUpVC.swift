//
//  SignUpVC.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 23.07.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI


class SignUpVC: UIViewController {
    
    
    //MARK: Properties/Outlets
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var usernameContainer: UIView!
    @IBOutlet weak var emailContainer: UIView!
    @IBOutlet weak var passwordContainer: UIView!
    
    var image: UIImage? = nil
    
    //MARK: Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        hideKeyboard()
        setupView()
        usernameTextFieldFunc()
        emailTextFieldFunc()
        passwordTextFieldFunc()
    }
    
    //MARK: Setup Methods
    
    
    func setupView(){
        
        signUpButton.layer.cornerRadius = 15
        
        profileImageView.layer.cornerRadius = 60
        profileImageView.clipsToBounds = true
        profileImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        profileImageView.addGestureRecognizer(tapGesture)
    }
    
    //MARK: Controls
    
    func validateFields(){
        guard let username = self.usernameTextField.text, !username.isEmpty else {
            alertFunc()
            return
        }
        guard let email = self.emailTextField.text, !email.isEmpty else {
            alertFunc()
            return
        }
        guard let password = self.passwordTextField.text, !password.isEmpty else {
            alertFunc()
            return
        }
        if profileImageView == nil {
            alertFunc()
        }
    }
    
    //MARK: Actions
    
    @IBAction func signUp(_ sender: UIButton) {
        
        self.validateFields()
        self.signUp()
        
        
    }
    
    
    @IBAction func toLogin(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "toSignInVC") as! SignInVC
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
        
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
    
    func alertFunc(){
        let alert = UIAlertController(title: "Error!", message: "Make sure you fill in the blank fields and try again.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Try Again!", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
//MARK: PHPickerViewControllerDelegate

extension SignUpVC: PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for item in results {
            item.itemProvider.loadObject(ofClass: UIImage.self) { Image, error in
                if let imageSelected = Image as? UIImage {
                    DispatchQueue.main.async {
                        self.profileImageView.image = imageSelected
                        self.image = imageSelected
                    }
                }
            }
        }
        dismiss(animated: true)
    }
    
    @objc func presentPicker(){
        var config: PHPickerConfiguration = PHPickerConfiguration()
        config.filter = PHPickerFilter.images
        config.selectionLimit = 1
        
        let picker : PHPickerViewController = PHPickerViewController(configuration: config)
        picker.delegate = self
        self.present(picker, animated: true)
        
    }
}

//MARK: DATA Function

extension SignUpVC{
    func signUp(){
        Api.User.signUp(withUsername: self.usernameTextField.text!, email: self.emailTextField.text!, password: self.passwordTextField.text!, image: self.image) {
            let scene = UIApplication.shared.connectedScenes.first
            if let sceneDelegate : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                sceneDelegate.configInitialVC()
            }
            
        } onErr: { errorMesssage in
            print(errorMesssage)
        }
        
    }
}
