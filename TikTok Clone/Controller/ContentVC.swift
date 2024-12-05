//
//  CreateContentVC.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 12.08.2024.
//

import UIKit
import AVFoundation

class ContentVC: UIViewController {
    
    // MARK: - UI Elements - Properties
    
    
    
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
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var discardButton: UIButton!
    
    
    let photoOutput = AVCapturePhotoOutput()
    let captureSession = AVCaptureSession()
    let movieOutput = AVCaptureMovieFileOutput()
    var activeInput : AVCaptureDeviceInput!
    var outputUrl : URL!
    var currentCamDevice : AVCaptureDevice?
    var thumbnailImage : UIImage?
    var recordClips = [Videos]()
    var isRecording = false
    
    var videoDurOfLastClip = 0
    var recordingTimer: Timer?
    var currentMaxRecDur: Int = 15 {
        didSet {
            timeCounterLabel.text = "\(currentMaxRecDur)s"
        }
    }
    
    var totalRecTimeInSecs = 0
    var totalRecTimeInMins = 0
    lazy var segmentProView = ProgressView(width: view.frame.width - 17.5)
    
    // MARK: - Lifecycle Methods
    
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
        hideTabBarAndNavigationBar()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBarAndNavigationBar()
        
    }
    
    // MARK: - Button Actions
    
    @IBAction func captureButtonTapped(_ sender: UIButton) {
        didTapRecord()
    }
    
    @IBAction func discardButton(_ sender: UIButton) {
        showDiscardAlert()
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        saveRecording()
    }
    
    @IBAction func flipButtonTapped(_ sender: UIButton) {
        flipCamera()
    }
    
    @IBAction func dismissButton(_ sender: UIButton) {
        tabBarController?.selectedIndex = 0
    }
    
    // MARK: - Camera Setup
    
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
    
    // MARK: - Recording Management
    func startRecording(){
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
                animatedRecordButton()
            }
        }
        
    }
    
    func stopRecording(){
        if movieOutput.isRecording == true {
            movieOutput.stopRecording()
            animatedRecordButton()
            stopTimer()
            segmentProView.pauseProgress()
            print("STOP COUNT")
        }
    }
    
    func saveRecording(){
        let previewVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "PreviewVC") { coder -> PreviewVC? in
            PreviewVC(coder: coder, recordedClips: self.recordClips)
        }
        previewVC.viewWillDenitRestartVideo = { [weak self] in
            guard let self = self else {return}
            if self.setupCaptureSession() {
                DispatchQueue.global(qos: .background).async {
                    self.captureSession.stopRunning()
                }
            }
            
        }
        navigationController?.pushViewController(previewVC, animated: true)
    }
    
    
    func didTapRecord() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    func discardLastRecord(){
        print("Discarded")
        outputUrl = nil
        thumbnailImage = nil
        recordClips.removeLast()
        resetAllVisibilitytoId()
        setNewOutputUrlThumImage()
        segmentProView.removeLastSegment()
        
        
        if recordClips.isEmpty == true {
            resetTimersAndProgressToZero()
        } else if recordClips.isEmpty == false {
            calculateDurLeft()
        }
        
    }
    
    func setNewOutputUrlThumImage(){
        outputUrl = recordClips.last?.videoUrl
        let currentUrl: URL? = outputUrl
        guard let currentUrlUnwrapped = currentUrl else {return}
        guard let generatedThumbImage = genVideoThum(withfile: currentUrlUnwrapped) else {return}
        if currentCamDevice?.position == .front {
            
            thumbnailImage = didGetPicture(generatedThumbImage, to: .upMirrored)
            
        }else {
            thumbnailImage = generatedThumbImage
        }
    }
    
    //MARK: Time Methods
    
    func startTimer(){
        videoDurOfLastClip = 0
        stopTimer()
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] _ in
            self?.timerTick()
            
        })
    }
    
    func timerTick(){
        totalRecTimeInSecs += 1
        videoDurOfLastClip += 1
        
        
        let timeLim = currentMaxRecDur * 10
        if totalRecTimeInSecs == timeLim {
            
            didTapRecord()
        }
        let startTime = 0
        let trimmedTime : Int = Int(currentMaxRecDur) - startTime
        let positiveOrZero = max(totalRecTimeInSecs, 0)
        let progress = Float(positiveOrZero) / Float(trimmedTime) / 10
        segmentProView.setProgress(CGFloat(progress))
        
        let countDowmSec: Int = max(0, Int(currentMaxRecDur) - totalRecTimeInSecs / 10)
        timeCounterLabel.text = "\(countDowmSec)s"
    }
    
    func stopTimer(){
        recordingTimer?.invalidate()
    }
    
    
    func calculateDurLeft(){
        let timeToDiscard = videoDurOfLastClip
        let currentCombTime = totalRecTimeInSecs
        let newVideoDur = currentCombTime - timeToDiscard
        totalRecTimeInSecs = newVideoDur
        let countDownSec: Int = Int(currentMaxRecDur) - totalRecTimeInSecs / 10
        timeCounterLabel.text = "\(countDownSec)"
    }
    
    func resetTimersAndProgressToZero(){
        totalRecTimeInSecs = 0
        totalRecTimeInMins = 0
        videoDurOfLastClip = 0
        stopTimer()
        segmentProView.setProgress(0)
        timeCounterLabel.text = "\(currentMaxRecDur)"
    }
    
    //MARK: Camera Actions
    func flipCamera(){
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
    
    // MARK: - Helper Methods
    
    func showDiscardAlert(){
        let alertVC = UIAlertController(title: "Discard Last Clip ?", message: nil, preferredStyle: .alert)
        let discardAction = UIAlertAction(title: "Discard", style: .default) { [weak self] (_) in
            self!.discardLastRecord()
            
        }
        let keepAction = UIAlertAction(title: "Keep!", style: .cancel) { (_) in
            
            
        }
        alertVC.addAction(discardAction)
        alertVC.addAction(keepAction)
        present(alertVC, animated: true)
    }
    
    
    
    func tempUrl() -> URL? {
        let directory = NSTemporaryDirectory() as NSString
        
        if directory != "" {
            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
            return URL(fileURLWithPath: path)
        }
        return nil
    }
    
    
    func animatedRecordButton(){
        isRecording = !isRecording
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: { [weak self] in
            guard let self = self else { return }
            if self.isRecording {
                self.captureButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.captureButton.layer.cornerRadius = 5
                self.captureRingView.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
                
                self.saveButton.alpha = 0
                self.discardButton.alpha = 0
                
                [self.galleryButton, self.effectsButton, self.soundsView].forEach { subView in
                    subView?.isHidden = true
                }
            } else {
                self.captureButton.transform = CGAffineTransform.identity
                self.captureButton.layer.cornerRadius = 68/2
                self.captureRingView.transform = CGAffineTransform.identity
                
                self.resetAllVisibilitytoId()
            }
        })
    }
    
    
    
    
    func resetAllVisibilitytoId(){
        
        if recordClips.isEmpty == true {
            [self.galleryButton, self.effectsButton, self.soundsView].forEach { subView in
                subView?.isHidden = false
            }
            saveButton.alpha = 0
            discardButton.alpha = 0
            print("THERE IS NO RECORD")
        }else {
            [self.galleryButton, self.effectsButton, self.soundsView].forEach { subView in
                subView?.isHidden = true
            }
            saveButton.alpha = 1
            discardButton.alpha = 1
            print("THERE IS A RECORD")
        }
    }
    
}




// MARK: - AVCaptureFileOutputRecordingDelegate

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
        startTimer()
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

//MARK: View Constraints


extension ContentVC {
    
    
    
    func setupView(){
        overrideUserInterfaceStyle = .light
        
        
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
        saveButton.layer.cornerRadius = 17
        saveButton.backgroundColor =  UIColor(red: 254/255, green: 44/255, blue: 85/255, alpha: 1.0)
        saveButton.alpha = 0
        discardButton.alpha = 0
        
        
        view.addSubview(segmentProView)
        segmentProView.topAnchor.constraint(equalTo: view.topAnchor, constant: 55).isActive = true
        segmentProView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentProView.widthAnchor.constraint(equalToConstant: view.frame.width - 17.5).isActive = true
        segmentProView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        segmentProView.translatesAutoresizingMaskIntoConstraints = false
        
        
        [self.captureButton, self.captureRingView, self.cancelButton, self.flipButton, self.flipLabel, self.speedLabel, self.speedButton, self.beautyLabel, self.beautyButton, self.filtersLabel, self.filtersButton, self.timerLabel, self.timerButton, self.galleryButton, self.effectsButton, self.soundsView, self.timeCounterLabel, self.flashLabel, self.flashButton, self.saveButton, self.discardButton].forEach { subView in
            subView?.layer.zPosition = 1
        }
    }
}
