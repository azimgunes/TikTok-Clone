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

class UserApi: SignInVC {
    
    func signIn(email: String, password: String, onSuc: @escaping() -> Void, onErr: @escaping(_ errorMesssage: String) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { authData, error in
            if error != nil {
                onErr("HATA BURADA \(error!.localizedDescription)")
                return
            }else {
                print(authData?.user.uid)
                onSuc()
            }
        }
        
    }
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
                
                let storageRef = Storage.storage().reference(forURL: "gs://tiktok-app-2da8e.firebasestorage.app")
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
    
    func observeUsers(completion: @escaping (User) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("users").addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching users: \(error?.localizedDescription ?? "No error description")")
                return
            }
            
            for document in snapshot.documents {
                let data = document.data()
                let user = User.transformUser(dict: data, key: document.documentID)
                completion(user)
                
            }
        }
    }
    
    func saveUserProfile(dict: [String: Any], onSuc: @escaping() -> Void, onErr: @escaping(_ errorMessage: String) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        
        userRef.updateData(dict) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                onErr(error.localizedDescription)
                return
            }
            onSuc()
        }
    }
    func deleteAccount() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        let storage = Storage.storage()
        
        db.collection("users").document(uid).delete { error in
            if let error = error {
                print("Error removing user document from users collection: \(error.localizedDescription)")
            } else {
                print("User document successfully removed from users collection!")
            }
        }
        
        db.collection("Posts").whereField("uid", isEqualTo: uid).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching user's posts: \(error.localizedDescription)")
            } else {
                guard let documents = snapshot?.documents else { return }
                for document in documents {
                    document.reference.delete { error in
                        if let error = error {
                            print("Error deleting post: \(error.localizedDescription)")
                        } else {
                            print("Post successfully deleted")
                        }
                    }
                }
            }
        }
        
        
        
        Auth.auth().currentUser?.delete { error in
            if let error = error {
                print("Error deleting user from Auth: \(error.localizedDescription)")
            } else {
                print("User successfully deleted from Auth")
            }
        }
        
        let storageRef = storage.reference()
        
        let profileRef = storageRef.child("profile").child(uid)
        profileRef.delete { error in
            if let error = error {
                print("Error deleting profile image: \(error.localizedDescription)")
            } else {
                print("Profile image successfully deleted")
            }
        }
        
        let postsRef = storageRef.child("posts").child(uid)
        postsRef.listAll { (result, error) in
            if let error = error {
                print("Error listing posts: \(error.localizedDescription)")
            } else {
                for item in result!.items {
                    item.delete { error in
                        if let error = error {
                            print("Error deleting post file: \(error.localizedDescription)")
                        } else {
                            print("Post file successfully deleted")
                        }
                    }
                }
            }
        }
        
        let postImagesRef = storageRef.child("post_images").child(uid)
        postImagesRef.listAll { (result, error) in
            if let error = error {
                print("Error listing post images: \(error.localizedDescription)")
            } else {
                for item in result!.items {
                    item.delete { error in
                        if let error = error {
                            print("Error deleting post image: \(error.localizedDescription)")
                        } else {
                            print("Post image file successfully deleted")
                        }
                    }
                }
            }
        }
    }
    
    
    func observeUser(withId uid: String, completion: @escaping (User) -> Void) {
        Firestore.firestore().collection("users").document(uid).getDocument { (document, error) in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists, let dict = document.data() else {
                print("Document does not exist")
                return
            }
            
            let user = User.transformUser(dict: dict, key: document.documentID)
            completion(user)
        }
        
    }
    
    
    func observeProfileUser(completion: @escaping (User) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").document(uid).getDocument { (document, error) in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                return
            }
            
            
            guard let document = document, document.exists, let dict = document.data() else {
                print("Document does not exist")
                return
            }
            
            let user = User.transformUser(dict: dict, key: document.documentID)
            completion(user)
        }
        
        
    }
    
    
    func logOut(){
        do {
            try Auth.auth().signOut()
        }catch {
            print("CATCH ERROR")
            return
        }
        let scene = UIApplication.shared.connectedScenes.first
        if let sceneDelegate : SceneDelegate = (scene?.delegate as? SceneDelegate) {
            sceneDelegate.configInitialVC()
        }
    }
}


