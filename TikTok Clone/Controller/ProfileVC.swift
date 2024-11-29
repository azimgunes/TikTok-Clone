//
//  ProfileVC.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 12.08.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import SDWebImage


class ProfileVC: UIViewController {
    
    //MARK: Properties/Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var user: User?
    
    var posts = [Post]()
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchUser()
        fetchAllPosts()
        vcSettings()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUser()
    }
    
    //MARK: Setup Methods
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationController?.navigationBar.tintColor = .black
        
    }
    
    //MARK: DATA
    
    func fetchAllPosts() {
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            print("No user is logged in")
            return
        }
        
        Firestore.firestore().collection("Posts")
            .whereField("uid", isEqualTo: currentUserUID)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching posts: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No posts found")
                    return
                }
                
                self.posts.removeAll()
                
                for document in documents {
                    let data = document.data()
                    let post = Post.transformPostVideo(dict: data, key: document.documentID)
                    self.posts.append(post)
                }
                
                self.collectionView.reloadData()
            }
    }
    
    
    func fetchUser(){
        Api.User.observeProfileUser { user in
            self.user = user
            self.collectionView.reloadData()
            
        }
    }
    
    // MARK: - Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileDetailSegue" {
            let detailVC = segue.destination as! DetailVC
            let postId = sender as! String
            detailVC.postId = postId
        }
    }
    
    
    //MARK: Actions
    
    @IBAction func editProfileButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editVC = storyboard.instantiateViewController(withIdentifier: "EditVC") as! EditVC
        self.navigationController?.pushViewController(editVC, animated: true)
        
        
    }
    
}
// MARK: - Collection View Data Source/Delegate, and FlowLayout

extension ProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //FlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = collectionView.frame.size
        
        
        return CGSize(width: size.width / 3 - 2, height: size.height / 3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    //Data Source/Delegate
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
// MARK: - Extension for Image Loading

extension UIImageView {
    func loadImage(_ urlString: String?) {
        guard let string = urlString, let url = URL(string: string) else {
            self.image = nil
            return
        }
        
        self.sd_setImage(with: url, placeholderImage: UIImage(named: "Space"))
    }
}


//MARK: PostProfileCVCDelegate

extension ProfileVC: PostProfileCVCDelegate {
    func toDetailVC(postId: String) {
        print("Segue, postId: \(postId)")
        
        performSegue(withIdentifier: "profileDetailSegue", sender: postId)
    }
    
    
}
