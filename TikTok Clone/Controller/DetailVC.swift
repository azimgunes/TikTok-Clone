//
//  DetailVC.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 4.10.2024.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var postId = ""
    var post = Post()
    var user = User()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        loadPost()
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        

    }
    func loadPost(){
        Api.Post.observePost(postId: postId) { post in
            guard let postUid = post.uid else {return}
            
            self.fetchUser(uid: postUid) {
                self.post = post
                self.collectionView.reloadData()
            }
        }
    }
    
    
    func fetchUser(uid: String, completion: @escaping() -> Void){
        Api.User.observeUser(withId: uid) { user in
            self.user = user
            completion()
        }
        
    }


}
extension DetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as! HomeCollectionViewCell
        cell.post = post
        cell.user = user
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
