//
//  Extensions.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 13.08.2024.
//

import Foundation
import UIKit


extension UIViewController {
    
    //MARK: Keyboard Helper
    
    func hideKeyboard(){
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tapGesture)}
    
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
    
    //MARK: Tab Bar Helper
    
    func hideTabBarAndNavigationBar() {
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func showTabBarAndNavigationBar() {
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: UI Settings Helper
    
    func vcSettings(){
        overrideUserInterfaceStyle = .light
        
        tabBarController?.tabBar.barTintColor =  .white
        tabBarController?.tabBar.tintColor = .black
        tabBarController?.tabBar.backgroundColor = .white
        
        navigationController?.navigationBar.barTintColor = .white
        
    }
    
}
