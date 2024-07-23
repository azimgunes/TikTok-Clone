//
//  SignUpVC.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 23.07.2024.
//

import UIKit

class SignUpVC: UIViewController {
    
    
    //MARK: Proporties
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()

        // Do any additional setup after loading the view.
    }
    
    func setupView(){
        profileImageView.layer.cornerRadius = 60
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.layer.borderWidth = 2.0
        
        signUpButton.layer.cornerRadius = 15
    }

}
