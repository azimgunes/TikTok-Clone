//
//  UserVC.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 9.10.2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class UserVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var user: User?

    var posts = [Post]()
    
    var userId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        fetchUser()
        fetchPost()
        
        
        overrideUserInterfaceStyle = .light
        
    }
    
    func fetchPost() {
        let db = Firestore.firestore()
        db.collection("User-Posts").whereField("userId", isEqualTo: userId).addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching posts: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            for document in snapshot.documents {
                let postId = document.documentID
                Api.Post.observePost(postId: postId) { post in
                    self.posts.append(post)
                    self.collectionView.reloadData()
                }
            }
        }
    }

    
   

    func fetchUser(){
        Api.User.observeUser(withId: userId) { user in
            self.user = user
            self.collectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromProfileToDetailVC" {
            let detailVC = segue.destination as? DetailVC
            let postId = sender as! String
            detailVC?.postId = postId
        }
    }
}
extension UserVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let size = collectionView.frame.size
        

        return CGSize(width: size.width / 3 - 2, height: size.height / 3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostProfileCVC", for: indexPath) as! PostProfileCVC
        let post = posts[indexPath.item]
        cell.post = post
        cell.delegate = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerCiewCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ProfileHeaderCRV", for: indexPath) as! ProfileHeaderCRV
            headerCiewCell.setupView()
            if let user = self.user {
                headerCiewCell.user = user

            }
            return headerCiewCell
            
        }
        return UICollectionReusableView()
    }
    
    
}

extension UserVC: PostProfileCVCDelegate {
    func toDetailVC(postId: String) {
        performSegue(withIdentifier: "fromProfileToDetailVC", sender: postId)
    }
    
    
}
