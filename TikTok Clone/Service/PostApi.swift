import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI

class PostApi {
    
    func sharePost(encodedVideoURL: URL?, selectedPhoto: UIImage?, textView: UITextView, onSuc: @escaping() -> Void, onErr: @escaping(_ errorMessage: String) -> Void) {
        
        let creationDate = Date().timeIntervalSince1970
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        if let encodedVideoURLUnwrapped = encodedVideoURL {
            let videoIdString = "\(UUID().uuidString).mp4"
            let storageRef = Storage.storage().reference(forURL: "gs://tiktok-clone-12238.appspot.com")
            let videoRef = storageRef.child("posts").child(videoIdString)
            let videoMetadata = StorageMetadata()
            videoMetadata.contentType = "video/mp4" // İçerik türünü belirtin
            
            videoRef.putFile(from: encodedVideoURLUnwrapped, metadata: videoMetadata) { metadata, error in
                if let error = error {
                    onErr("Error uploading video: \(error.localizedDescription)")
                    return
                }
                
                videoRef.downloadURL { videoUrl, error in
                    if let error = error {
                        onErr("Error getting video URL: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let videoUrlString = videoUrl?.absoluteString else {
                        onErr("Video URL is nil")
                        return
                    }
                    
                    self.uploadThumbImageToFirestore(selectedPhoto: selectedPhoto) { postImageUrl in
                        let values: [String: Any] = [
                            "creationDate": creationDate,
                            "imageUrl": postImageUrl,
                            "videoUrl": videoUrlString,
                            "description": textView.text!,
                            "likes": 0,
                            "views": 0,
                            "commentCount": 0,
                            "uid": uid
                        ]
                        let postRef = Firestore.firestore().collection("Posts")
                        
                        postRef.addDocument(data: values) { error in
                            if let error = error {
                                onErr("Error saving: \(error.localizedDescription)")
                            } else {
                                guard let documentID = postRef.document().documentID as String? else {
                                    onErr("Failed document ID")
                                    return
                                }
                                
                                let userPostRef = Firestore.firestore().collection("User-Posts").document(uid)
                                
                                userPostRef.setData([uid: uid], merge: true) { error in
                                    if let error = error {
                                        onErr("Error updating: \(error.localizedDescription)")
                                    } else {
                                        print("User-Posts updated")
                                        onSuc()
                                        
                                        userPostRef.updateData([documentID: 1]) { error in
                                            if let error = error {
                                                onErr("Error updating: \(error.localizedDescription)")
                                            } else {
                                                print("Successfully updated")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        
                        
                        
                        
                    }
                }
            }
        }
    }
    
    
    func uploadThumbImageToFirestore(selectedPhoto: UIImage?, completion: @escaping (String) -> ()) {
        guard let thumbnailImage = selectedPhoto, let imageData = thumbnailImage.jpegData(compressionQuality: 0.3) else {
            completion("No image data")
            return
        }
        
        let photoIdString = UUID().uuidString
        let storageRef = Storage.storage().reference(forURL: "gs://tiktok-clone-12238.appspot.com")
        let imageRef = storageRef.child("post_images").child(photoIdString)
        let imageMetadata = StorageMetadata()
        imageMetadata.contentType = "image/jpeg" // İçerik türünü belirtin
        
        imageRef.putData(imageData, metadata: imageMetadata) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion("Error uploading image")
                return
            }
            
            imageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting image URL: \(error.localizedDescription)")
                    completion("Error getting image URL")
                    return
                }
                
                guard let postImageUrl = url?.absoluteString else {
                    completion("Image URL is nil")
                    return
                }
                
                completion(postImageUrl)
            }
        }
    }
    
    
}
