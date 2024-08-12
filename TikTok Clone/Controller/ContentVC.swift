//
//  CreateContentVC.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 12.08.2024.
//

import UIKit

class ContentVC: UIViewController {
    
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var captureButton: UIButton!
    
    @IBOutlet weak var captureRingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setupView(){
        captureButton.backgroundColor = UIColor(red: 254/255, green: 44/255, blue: 85/255, alpha: 1.0)
        captureButton.layer.cornerRadius = 68/2
        captureRingView.layer.borderColor = UIColor(red: 254/255, green: 44/255, blue: 85/255, alpha: 1.0).cgColor
        captureRingView.layer.borderWidth = 6
        captureRingView.layer.cornerRadius = 85/2
    }


}
