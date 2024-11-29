//
//  StorageService.swift
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


class StorageService{
    static func savePhoto(username: String, uid: String, data: Data, metadata: StorageMetadata, storageProfileRef: StorageReference, dict: Dictionary<String, Any>, onSuc: @escaping() -> Void, onErr: @escaping(_ errorMesssage: String) -> Void){
        
        
        storageProfileRef.putData(data, metadata: metadata) { storageMetaData, error in
            if error != nil {
                onErr(error!.localizedDescription)
                return
            }
            
            
            storageProfileRef.downloadURL { url, error in
                if let metaImageUrl = url?.absoluteString {
                    if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                        changeRequest.photoURL = url
                        changeRequest.displayName = username
                        changeRequest.commitChanges { error in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                    }
                    var dictTemp = dict
                    dictTemp["profileImageUrl"] = metaImageUrl
                    
                    Firestore.firestore().collection("users").document(uid).updateData(dictTemp) { error in
                        if error == nil {
                            onSuc()
                        }else {
                            onErr(error!.localizedDescription)
                        }
                    }
                }
            }
        }
    }
}
