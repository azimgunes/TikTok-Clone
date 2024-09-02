//
//  ShareVC.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 31.08.2024.
//

import UIKit
import AVFoundation

class ShareVC: UIViewController {
    
    
    @IBOutlet weak var thumbImageView: UIImageView!
    let originalVideoUrl: URL
    var selectedPhoto : UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black

        // Do any additional setup after loading the view.
    }
    

    init?(coder: NSCoder, videoUrl: URL) {
        self.originalVideoUrl = videoUrl
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
