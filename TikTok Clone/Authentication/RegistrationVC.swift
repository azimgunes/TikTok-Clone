//
//  ViewController.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 22.07.2024.
//

import UIKit

class RegistrationVC: UIViewController {
    
    //MARK: Properties/Outlets
    
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    //MARK: Setup
    
    func setupView(){
        overrideUserInterfaceStyle = .light
        self.navigationController?.navigationBar.tintColor = .black
        signupButton.layer.cornerRadius = 15
        loginButton.layer.cornerRadius = 15
        
    }
    
    //MARK: Action Methods
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "toSignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func signInTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "toSignInVC") as! SignInVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

