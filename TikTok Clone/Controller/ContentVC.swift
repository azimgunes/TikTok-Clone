//
//  CreateContentVC.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 12.08.2024.
//

import UIKit
import AVFoundation

class ContentVC: UIViewController {
    
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var captureButton: UIButton!
    
    @IBOutlet weak var captureRingView: UIView!
    
    
    let photoOutput = AVCapturePhotoOutput()
    let captureSession = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if setupCaptureSession(){
            DispatchQueue.global(qos: .background).async {
                self.captureSession.startRunning()
            }
        }
        
        setupView()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setupView(){
        captureButton.backgroundColor = UIColor(red: 254/255, green: 44/255, blue: 85/255, alpha: 1.0)
        captureButton.layer.cornerRadius = 68/2
        captureRingView.layer.borderColor = UIColor(red: 254/255, green: 44/255, blue: 85/255, alpha: 1.0).cgColor
        captureRingView.layer.borderWidth = 6
        captureRingView.layer.cornerRadius = 85/2
        
        captureButton.layer.zPosition = 1
        captureRingView.layer.zPosition = 1
        cancelButton.layer.zPosition = 1
    }
    
    func setupCaptureSession() -> Bool{
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        
        //INPUTS
        if let captureVideoDevice = AVCaptureDevice.default(for: AVMediaType.video),
           let captureAudioDevice = AVCaptureDevice.default(for: AVMediaType.audio) {
            do {
                let inputVideo = try AVCaptureDeviceInput(device: captureVideoDevice)
                let inputAudio = try AVCaptureDeviceInput(device: captureAudioDevice)
                
                if captureSession.canAddInput(inputVideo) {
                    captureSession.addInput(inputVideo)
                }
                if captureSession.canAddInput(inputAudio) {
                    captureSession.addInput(inputAudio)
                }
            } catch let error {
                print("ERROR - SESSİON", error)
                return false
                
            }
        }
        //OUTPUTS
        if captureSession.canAddOutput(photoOutput){
            captureSession.addOutput(photoOutput)
        }
        //Previews
        let preLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        preLayer.frame = view.frame
        preLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(preLayer)
        return true
    }


}
