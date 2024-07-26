//
//  SignInVC.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 24.07.2024.
//

import UIKit

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

    }
    
    
    func setupView(){
        signInButton.layer.cornerRadius = 10
  
    }

}
