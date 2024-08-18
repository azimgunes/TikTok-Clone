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
    
    @IBOutlet weak var flipButton: UIButton!
    
    @IBOutlet weak var flipLabel: UILabel!
    
    @IBOutlet weak var speedButton: UIButton!
    
    @IBOutlet weak var speedLabel: UILabel!
    
    @IBOutlet weak var beautyButton: UIButton!
    
    @IBOutlet weak var beautyLabel: UILabel!
    
    @IBOutlet weak var timerButton: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var flashButton: UIButton!
    
    @IBOutlet weak var flashLabel: UILabel!
    
    @IBOutlet weak var galleryButton: UIButton!
    
    @IBOutlet weak var effectsButton: UIButton!
    
    @IBOutlet weak var soundsView: UIView!
    
    @IBOutlet weak var filtersButton: UIButton!
    
    @IBOutlet weak var filtersLabel: UILabel!
    
    
    @IBOutlet weak var timeCounterLabel: UILabel!
    
    
    
    
    let photoOutput = AVCapturePhotoOutput()
    let captureSession = AVCaptureSession()
    let movieOutput = AVCaptureMovieFileOutput()
    
    var activeInput : AVCaptureDeviceInput!
    var outputUrl : URL!
    var currentCamDevice : AVCaptureDevice?
    var thumbnailImage : UIImage?
    var recordClips = [Videos]()
    
    
    
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
    
    
    @IBAction func captureButtonTapped(_ sender: UIButton) {
        if movieOutput.isPrimaryConstituentDeviceSwitchingBehaviorForRecordingEnabled == false {
            startRec()
        } else {
            stopRec()
        }
    }
    
    
    func setupView(){
        captureButton.backgroundColor = UIColor(red: 254/255, green: 44/255, blue: 85/255, alpha: 1.0)
        captureButton.layer.cornerRadius = 68/2
        captureRingView.layer.borderColor = UIColor(red: 254/255, green: 44/255, blue: 85/255, alpha: 1.0).cgColor
        captureRingView.layer.borderWidth = 6
        captureRingView.layer.cornerRadius = 85/2
        

        timeCounterLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        timeCounterLabel.layer.cornerRadius = 15
        timeCounterLabel.layer.borderColor = UIColor.white.cgColor
        timeCounterLabel.layer.borderWidth = 1.8
        timeCounterLabel.clipsToBounds = true
        
        soundsView.layer.cornerRadius = 12
        
        
        
        [self.captureButton, self.captureRingView, self.cancelButton, self.flipButton, self.flipLabel, self.speedLabel, self.speedButton, self.beautyLabel, self.beautyButton, self.filtersLabel, self.filtersButton, self.timerLabel, self.timerButton, self.galleryButton, self.effectsButton, self.soundsView, self.timeCounterLabel, self.flashLabel, self.flashButton].forEach { subView in
            subView?.layer.zPosition = 1
        }
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
                    activeInput = inputVideo
                }
                if captureSession.canAddInput(inputAudio) {
                    captureSession.addInput(inputAudio)
                }
                
                if captureSession.canAddOutput(movieOutput){
                    captureSession.addOutput(movieOutput)
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

    @IBAction func dismissButton(_ sender: UIButton) {
        tabBarController?.selectedIndex = 0
    }
    
    func tempUrl() -> URL? {
        let directory = NSTemporaryDirectory() as NSString
        
        if directory != "" {
            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
            return URL(fileURLWithPath: path)
        }
        return nil
    }
    
    @IBAction func flipDidTapped(_ sender: UIButton) {
        captureSession.beginConfiguration()
        
        let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput
        let newCamDevice = currentInput?.device.position == .back ? getDeviceFront(position: .front) : getDeviceBack(position: .back)
        
        let newVideoInput = try? AVCaptureDeviceInput(device: newCamDevice!)
        
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput]{
            for input in inputs {
                captureSession.removeInput(input)
            }
        }
        
        if captureSession.inputs.isEmpty {
            captureSession.addInput(newVideoInput!)
            activeInput = newVideoInput
        }
        
        
        if let microphone = AVCaptureDevice.default(for: .audio){
            do {
                let micInput = try AVCaptureDeviceInput(device: microphone)
                if captureSession.canAddInput(micInput){
                    captureSession.addInput(micInput)
                }
            }catch let micInputError{
                print("DEVICE ERROR FOR AUDIO INPUT: \(micInputError)")
                
            }
        }
        captureSession.commitConfiguration()
        
    }
    func getDeviceFront(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    }
    func getDeviceBack(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
    }
    func startRec(){
        if movieOutput.isRecording == false {
            guard let connection = movieOutput.connection(with: .video) else {return}
            if connection.isVideoOrientationSupported {
                connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
                let device = activeInput.device
                if device.isSmoothAutoFocusEnabled {
                    do {
                        try device.lockForConfiguration()
                        device.isSmoothAutoFocusEnabled = false
                        device.unlockForConfiguration()
                    } catch {
                        print("CONFIG ERROR: \(error)")
                    }
                }
                outputUrl = tempUrl()
                movieOutput.startRecording(to: outputUrl, recordingDelegate: self)
            }
        }
    }
    func stopRec(){
        if movieOutput.isRecording == true {
            movieOutput.stopRecording()
            print("STOP COUNT")
        }
    }
}

extension ContentVC: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if error != nil {
            print("RECORDİNG ERROR: \(error?.localizedDescription ?? "")")
        }else {
            let urlVideoRec = outputUrl! as URL
            
            guard let generatedThumbImage = genVideoThum(withfile: urlVideoRec) else {return}
            
            
            if currentCamDevice?.position == .front {
                thumbnailImage = didGetPicture(generatedThumbImage, to: .upMirrored)
            }else{
                thumbnailImage = generatedThumbImage
            }
             
            
            
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        let newRecClip = Videos(videoUrl: fileURL, cameraPosition: currentCamDevice?.position)
        recordClips.append(newRecClip)
        print("MOVIE RECORD",recordClips.count)
    }
    
    func didGetPicture(_ picture: UIImage, to orientation: UIImage.Orientation) -> UIImage {
        let flippedImage = UIImage(cgImage: picture.cgImage!, scale: picture.scale, orientation: orientation)
        return flippedImage
    }
    func genVideoThum(withfile videoUrl: URL) -> UIImage? {
        let asset = AVAsset(url: videoUrl)
        
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        do{
            let cmTime = CMTimeMake(value: 1, timescale: 60)
            let thumbnailCgImage = try imageGenerator.copyCGImage(at: cmTime, actualTime: nil)
            return UIImage(cgImage: thumbnailCgImage)
        }catch let error{
            print(error)
            
        }
        return nil
    }
    
}
