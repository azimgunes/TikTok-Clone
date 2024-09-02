//
//  ShareVC.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 31.08.2024.
//

import UIKit
import AVFoundation

class ShareVC: UIViewController {
    
    //MARK: Proporties
    
    
    let originalVideoUrl: URL
    var selectedPhoto : UIImage?
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var selectLabel: UILabel!
    
    @IBOutlet weak var postBut: UIButton!
    @IBOutlet weak var draftsBut: UIButton!
    
    
    
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
    
    
    @IBAction func allowToComments(_ sender: UISwitch) {
    }
    
    
    @IBAction func allawDeuts(_ sender: UISwitch) {
    }
    
    @IBAction func allowAdding(_ sender: UISwitch) {
    }
    
    
    @IBAction func saveToDevice(_ sender: UISwitch) {
    }
    
    @IBAction func postButton(_ sender: UIButton) {
    }
    
    @IBAction func draftsButton(_ sender: UIButton) {
    }
    
}
