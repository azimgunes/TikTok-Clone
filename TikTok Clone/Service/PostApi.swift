import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI
import SDWebImage

class PostApi {
    
    func sharePost(encodedVideoURL: URL?, selectedPhoto: UIImage?, textView: UITextView, onSuc: @escaping() -> Void, onErr: @escaping(_ errorMessage: String) -> Void) {
        
        let creationDate = Date().timeIntervalSince1970
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        if let encodedVideoURLUnwrapped = encodedVideoURL {
            let videoIdString = "\(UUID().uuidString).mp4"
            let storageRef = Storage.storage().reference(forURL: "gs://tiktok-app-2da8e.firebasestorage.app")
            let videoRef = storageRef.child("posts").child(videoIdString)
            let videoMetadata = StorageMetadata()
            videoMetadata.contentType = "video/mp4"
            
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
        let storageRef = Storage.storage().reference(forURL: "gs://tiktok-app-2da8e.firebasestorage.app")
        let imageRef = storageRef.child("post_images").child(photoIdString)
        let imageMetadata = StorageMetadata()
        imageMetadata.contentType = "image/jpeg"
        
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
    func observePost(postId id: String, completion: @escaping (Post) -> Void) {
        Firestore.firestore().collection("Posts").document(id).addSnapshotListener { (documentSnapshot, error) in
            if let error = error {
                print("Error fetching post: \(error.localizedDescription)")
                return
            }
            
            guard let document = documentSnapshot else { return }
            let dict = document.data() ?? [:]
            let newPost = Post.transformPostVideo(dict: dict, key: document.documentID)
            completion(newPost)
        }
    }
    
    
    func observeFeedPost(completion: @escaping (Post) -> Void) {
        let db = Firestore.firestore()
        db.collection("Posts").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            
            if let snapshot = snapshot {
                let documents = snapshot.documents.reversed()
                for document in documents {
                    let data = document.data()
                    let post = Post.transformPostVideo(dict: data, key: document.documentID)
                    completion(post)
                }
            }
        }
    }
    
}




extension UIImageView {
    func loadImage(_ urlString: String?, onSuc: ((UIImage) -> Void)? = nil) {
        self.image = UIImage()
        guard let string = urlString else {return}
        
        guard let url = URL(string: string) else {return}
        
        self.sd_setImage(with: url) { image, error, type, url in
            if onSuc != nil, error == nil {
                onSuc!(image!)
            }
        }
    }
}
