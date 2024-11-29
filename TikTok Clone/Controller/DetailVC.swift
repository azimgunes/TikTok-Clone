//
//  DetailVC.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 4.10.2024.
//

import UIKit

class DetailVC: UIViewController {
    
    //MARK: Properties/Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var postId = ""
    var post = Post()
    var user = User()
    
    var activeVideoCell: HomeCollectionViewCell?
    
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPost()
        setupCollectionView()
        overrideUserInterfaceStyle = .light
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTappedOutside(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
    
    
    //MARK: Setup
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        navigationController?.navigationBar.tintColor = .black
        
    }
    
    //MARK: DATA
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
// MARK: - Collection View Data Source/Delegate, and FlowLayout

//Data Source/Delegate
extension DetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as! HomeCollectionViewCell
        cell.post = post
        cell.user = user
        cell.updateView()
        return cell
    }
    
    //Flow Layout
    
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? HomeCollectionViewCell {
            
            
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
}
