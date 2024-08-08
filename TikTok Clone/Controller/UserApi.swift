//
//  UserApi.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 9.08.2024.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI

class UserApi {
    func signUp(withUsername username: String, email: String, password: String, image: UIImage?, onSuc: @escaping() -> Void, onErr: @escaping(_ errorMesssage: String) -> Void) {
        
        guard let imageSelected = image else {
            return
        }
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {return}
        
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print("ERROR: \(error!.localizedDescription)")
                return
            }
                if let authData = result {
                    print("USER: \(authData.user.email!)")
                    var dictionary: Dictionary<String, Any> = [
                        
                        "uid": authData.user.uid,
                        "email": authData.user.email!,
                        "username": username,
                        "profileImageUrl": "",
                        "status": "",
                    ]
                    
                    let storageRef = Storage.storage().reference(forURL: "gs://tiktok-clone-12238.appspot.com")
                    let storageProfile = storageRef.child("profile").child(authData.user.uid)
                    
                    let metaData = StorageMetadata()
                    metaData.contentType = "image/jpeg"
                    
                    StorageService.savePhoto(username: username, uid: authData.user.uid, data: imageData, metadata: metaData, storageProfileRef: storageProfile, dict: dictionary) {
                        onSuc()
                    }onErr: { errorMesssage in
                        onErr(errorMesssage)
                    }

                    
                    guard let userUid = result?.user.uid else {return}

                    Firestore.firestore().collection("users").document(userUid).setData(dictionary)
                    print("\(authData.user.email!) sended to Firestore.")
                    
                }
            
        }
    }
}
