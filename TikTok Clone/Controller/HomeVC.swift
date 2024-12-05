//
//  HomeVC.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 19.09.2024.
//

import UIKit

class HomeVC: UIViewController {
    
    //MARK: Properties/Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts = [Post]()
    var users = [User]()
    
    var user = [User]()
    
    var activeVideoCell: HomeCollectionViewCell?
    
    @objc dynamic var currentIndex = 0
    var oldAndNewIndices = (0,0)
    
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadPosts()
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTappedOutside(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        if let cell = collectionView.visibleCells.first as? HomeCollectionViewCell {
            cell.playVideo()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        if let cell = collectionView.visibleCells.first as? HomeCollectionViewCell {
            cell.pauseVideo()
        }
    }
    
    //MARK: Actions
    
    @objc func viewTappedOutside(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: self.view)
        if let tappedView = self.view.hitTest(tapLocation, with: nil), tappedView.isDescendant(of: collectionView) {
        } else {
            activeVideoCell?.stopVideo()
            activeVideoCell = nil
        }
    }
    
    
    // MARK: - Setup Methods
    func setupCollectionView(){
        
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = createFlowLayout()
        collectionView.backgroundColor = .black
        
        tabBarController?.tabBar.barTintColor = .black
        tabBarController?.tabBar.tintColor = .white
        tabBarController?.tabBar.backgroundColor = .black
        
    }
    
    
    // MARK: - DATA & SERVICE
    
    func loadPosts(){
        
        Api.Post.observeFeedPost { post in
            guard let postId = post.uid else {return}
            self.fetchUser(uid: postId) {
                self.posts.append(post)
                
                self.posts.sort { post1, post2 -> Bool in
                    return post1.creationDate! > post2.creationDate!
                }
                
                if self.posts.count == self.users.count {
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    func fetchUser(uid: String, completed: @escaping() -> Void ){
        Api.User.observeUser(withId: uid) { user in
            self.users.append(user)
            completed()
        }
    }
    
    //MARK: Prepare For Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fromHomeToUserVC" {
            let userVC = segue.destination as! UserVC
            let userId = sender as! String
            userVC.userId = userId
        }
        
    }
    
    
}

// MARK: - Cell Playback Control, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout


extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as! HomeCollectionViewCell
        let post = posts[indexPath.item]
        let user = users[indexPath.item]
        cell.post = post
        cell.user = user
        cell.delegate = self
        cell.backgroundColor = UIColor.black
        cell.updateView()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? HomeCollectionViewCell {
            activeVideoCell?.stopVideo()
            
            activeVideoCell = cell
            cell.playVideo()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? HomeCollectionViewCell {
            cell.stopVideo()
            if activeVideoCell == cell {
                activeVideoCell = nil
            }
        }
        
    }
    
    //Flow Layout
    
    private func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        return layout
    }
}

// MARK: - UIScrollViewDelegate


extension HomeVC: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleIndexPaths = collectionView.indexPathsForVisibleItems
        if let visibleIndexPath = visibleIndexPaths.first,
           let cell = collectionView.cellForItem(at: visibleIndexPath) as? HomeCollectionViewCell {
            activeVideoCell?.stopVideo()
            activeVideoCell = cell
            cell.playVideo()
        }
    }
}
//MARK: HomeCollectionViewCellDelegate

extension HomeVC: HomeCollectionViewCellDelegate {
    func toUserVC(userId: String) {
        performSegue(withIdentifier: "fromHomeToUserVC", sender: userId)
    }
    
    
}
