//
//  PreviewVC.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 24.08.2024.
//

import UIKit

class PreviewVC: UIViewController {
    
    //MARK: Proporties
    
    var currentPlayingVideo: Videos
    var recordedClips: [Videos] = []
    var viewWillDenitRestartVideo: (() -> Void)?
    
    deinit {
        print("PreviewVC was deineted")
        (viewWillDenitRestartVideo)?()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(recordedClips.count)")

    }
    init?(coder: NSCoder, recordedClips: [Videos]){
        self.currentPlayingVideo = recordedClips.first!
        self.recordedClips = recordedClips
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


}
