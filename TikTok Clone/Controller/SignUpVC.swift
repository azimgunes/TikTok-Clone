//
//  SignUpVC.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 23.07.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import PhotosUI


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
        profileImageView.layer.cornerRadius = 60
        profileImageView.clipsToBounds = true
        profileImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        profileImageView.addGestureRecognizer(tapGesture)
    }
    
    
    
    @IBAction func signUp(_ sender: UIButton) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { result, error in
            if error != nil {
                print("ERROR: \(error!.localizedDescription)")
                return
            }
                if let authData = result {
                    print("USER: \(authData.user.email!)")
                    let dictionary: Dictionary<String, Any> = [
                        
                        "uid": authData.user.uid,
                        "email": authData.user.email!,
                        "profileImageUrl": "",
                        "status": "",
                    ]
                    
                    guard let userUid = result?.user.uid else {return}

                    Firestore.firestore().collection("users").document(userUid).setData(dictionary)
                    print("\(authData.user.email!) sended to Firestore.")
                    
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


extension SignUpVC: PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for item in results {
            item.itemProvider.loadObject(ofClass: UIImage.self) { Image, error in
                if let imageSelected = Image as? UIImage {
                    DispatchQueue.main.async {
                        self.profileImageView.image = imageSelected
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
