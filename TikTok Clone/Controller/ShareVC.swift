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
    
    //MARK: Proporties
    
    
    let originalVideoUrl: URL
    var selectedPhoto : UIImage?
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var selectLabel: UILabel!
    
    @IBOutlet weak var postBut: UIButton!
    @IBOutlet weak var draftsBut: UIButton!
    
    
    let placeholder = "Write your explanation about the content."
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textViewDidChange()
        setupView()
        hideKeyboard()
        
        view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black

        if let thumbnailImage = self.thumbnailImageForFileUrl(originalVideoUrl) {
            self.selectedPhoto = thumbnailImage.imageRotated(by: Double.pi/2)
            thumbImageView.image = thumbnailImage.imageRotated(by: Double.pi/2)
        }
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBarAndNavigationBar()
 
   
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBarAndNavigationBar()
      
        
       
    }
    
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

    init?(coder: NSCoder, videoUrl: URL) {
        self.originalVideoUrl = videoUrl
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        draftsBut.layer.borderColor = UIColor.lightGray.cgColor
        draftsBut.layer.borderWidth = 0.3
        draftsBut.layer.cornerRadius = 15
        
        postBut.layer.cornerRadius = 15
        
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

extension ShareVC {
    // MARK: - Helper Methods
    private func hideTabBarAndNavigationBar() {
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func showTabBarAndNavigationBar() {
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
}
extension ShareVC{
    func textViewDidChange(){
        textView.delegate = self
        textView.text = placeholder
        textView.textColor = .lightGray
    }
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
