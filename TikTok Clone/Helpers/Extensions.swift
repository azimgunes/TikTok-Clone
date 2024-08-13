//
//  Extensions.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 13.08.2024.
//

import Foundation
import UIKit


extension UIViewController {
    func hideKeyboard(){
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tapGesture)}
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
    
    }
