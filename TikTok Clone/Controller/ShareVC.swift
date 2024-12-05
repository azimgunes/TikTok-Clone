//
//  ShareVC.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 31.08.2024.
//

import UIKit
import Foundation
import AVFoundation


class ShareVC: UIViewController, UITextViewDelegate {
    
    //MARK: Properties/Outlets
    
    
    let originalVideoUrl: URL
    var encodedVideoURL: URL?
    var selectedPhoto : UIImage?
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var selectLabel: UILabel!
    
    @IBOutlet weak var postBut: UIButton!
    @IBOutlet weak var draftsBut: UIButton!
    
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var toWhatsapp: UIButton!
    
    @IBOutlet weak var toSnapchat: UIButton!
    
    @IBOutlet weak var toInstagram: UIButton!
    
    
    let placeholder = "Write your explanation about the content."
    
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextView()
        setupView()
        hideKeyboard()
        loadThumb()
        saveToServer()
        
        overrideUserInterfaceStyle = .light
        view.backgroundColor = .white
        
    }
    
    
    init?(coder: NSCoder, videoUrl: URL) {
        self.originalVideoUrl = videoUrl
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBarAndNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBarAndNavigationBar()
    }
    
    //MARK: Setup Methods
    
    func setupView(){
        draftsBut.layer.borderColor = UIColor.lightGray.cgColor
        draftsBut.layer.borderWidth = 0.3
        draftsBut.layer.cornerRadius = 15
        
        postBut.layer.cornerRadius = 15
        
        toWhatsapp.contentMode = .scaleAspectFit
        
        backButton.target = self
        backButton.action = #selector(backToPreviewVC)
        
    }
    
    
    func setupTextView(){
        textView.delegate = self
        textView.text = placeholder
        textView.textColor = .lightGray
    }
    
    
    func loadThumb(){
        if let thumbnailImage = self.thumbnailImageForFileUrl(originalVideoUrl) {
            self.selectedPhoto = thumbnailImage.imageRotated(by: Double.pi/2)
            thumbImageView.image = thumbnailImage.imageRotated(by: Double.pi/2)
        }
    }
    
    // MARK: - Thumbnail Generator
    
    
    func thumbnailImageForFileUrl(_ fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 7, timescale: 1), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch {
            print(error)
        }
        return nil
    }
    
    // MARK: - Button Actions
    
    @IBAction func backToPreviewVC() {
        
        
        
        if let navController = navigationController {
            navController.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func postButton(_ sender: UIButton) {
        self.sharePost {
            self.dismiss(animated: true) {
                if let tabBarController = self.tabBarController {
                    let targetVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
                    tabBarController.navigationController?.pushViewController(targetVC!, animated: true)
                }
                
            }
        } onErr: { errorMessage in
            print(errorMessage)
        }
    }
    
    
    
    // MARK: - Sharing Post
    
    func sharePost(onSuc: @escaping() -> Void, onErr: @escaping(_ errorMessage: String) -> Void){
        Api.Post.sharePost(encodedVideoURL: encodedVideoURL, selectedPhoto: selectedPhoto, textView: textView) {
            print("SHARED.")
            onSuc()
        } onErr: { errorMessage in
            onErr(errorMessage)
        }
        
        
    }
    // MARK: - Save Video to Server
    
    func saveToServer(){
        saveVideoToServer(sourceURL: originalVideoUrl) {[weak self] (outputURL) in
            self?.encodedVideoURL = outputURL
        }
    }
    
    
    
}

// MARK: - UITextViewDelegate

extension ShareVC{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = placeholder
            textView.textColor = .lightGray
        }
    }
    
}

// MARK: - UIImage Extension for Rotation

extension UIImage {
    func imageRotated(by radian: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size).applying(CGAffineTransform(rotationAngle: radian)).integral.size
        
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radian)
            draw(in: CGRect(x: -size.width / 2.0, y: -size.height / 2.0, width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return rotatedImage ?? self
        }
        return self
    }
}
