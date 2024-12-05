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
    
    //MARK: Properties/Outlets
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var user: User?
    
    var posts = [Post]()
    
    var userId = ""
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchUser()
        fetchPost()
        vcSettings()
        navigationController?.navigationBar.tintColor = .black
        
    }
    
    //MARK: Setup Methods
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationController?.navigationBar.barTintColor = .black
    }
    //MARK: DATA
    
    func fetchPost() {
        let db = Firestore.firestore()
        db.collection("Posts").whereField("uid", isEqualTo: userId).addSnapshotListener { querySnapshot, error in
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
    
    //MARK: Actions 
    
    @IBAction func messageButtonTapped(_ sender: UIBarButtonItem) {
        guard let currentUser = user else { return }
        
        let chatUser = ChatUser(uid: currentUser.uid ?? "",
                                username: currentUser.username ?? "",
                                profileImageUrl: currentUser.profileImageUrl ?? "")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let chatVC = storyboard.instantiateViewController(withIdentifier: "ChatVC") as? ChatVC {
            chatVC.selectedUser = chatUser
            navigationController?.pushViewController(chatVC, animated: true)
        }
    }
    
    
    // MARK: - Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromProfileToDetailVC" {
            let detailVC = segue.destination as? DetailVC
            let postId = sender as! String
            detailVC?.postId = postId
        }
    }
}

// MARK: - Collection View Data Source/Delegate, and FlowLayout

extension UserVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //Flow Layout
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
    
    //Data Source/Delegate
    
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

//MARK: PostProfileCVCDelegate


extension UserVC: PostProfileCVCDelegate {
    func toDetailVC(postId: String) {
        performSegue(withIdentifier: "fromProfileToDetailVC", sender: postId)
    }
    
    
}
