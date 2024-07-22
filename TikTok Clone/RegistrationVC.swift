//
//  ViewController.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 22.07.2024.
//

import UIKit

class RegistrationVC: UIViewController {

    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }

    func setupView(){
        facebookButton.layer.cornerRadius = 15
        signupButton.layer.cornerRadius = 15
        googleButton.layer.cornerRadius = 15
        loginButton.layer.cornerRadius = 15

    }
}

