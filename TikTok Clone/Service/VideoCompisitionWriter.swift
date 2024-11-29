//
//  VideoCompisitionWriter.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 30.08.2024.
//

import AVFoundation
import UIKit

class VideoCompisitionWriter: NSObject {
    var exportSession: AVAssetExportSession?
    
    func mergeMultiVideo(urls: [URL], onComplete: @escaping(Bool, URL?) -> Void) {
        var totalDur = CMTime.zero
        var assets: [AVAsset] = []
        
        for url in urls {
            let asset = AVAsset(url: url)
            assets.append(asset)
            totalDur = CMTimeAdd(totalDur, asset.duration)
        }
        let outputUrl = createOutputUrl(with: urls.first!)
        let mixCompisition = merge(arrayVideo: assets)
        createExportSession(outputURL: outputUrl, mixCompisition: mixCompisition, onComplete: onComplete)
        
    }
    func createExportSession(outputURL: URL, mixCompisition: AVMutableComposition, onComplete: @escaping(Bool, URL?) -> Void) {
        exportSession = AVAssetExportSession(asset: mixCompisition, presetName: AVAssetExportPresetHighestQuality)
        exportSession?.outputURL = outputURL
        exportSession?.shouldOptimizeForNetworkUse = true
        
        exportSession?.outputFileType = AVFileType.mp4
        
        var exportProgressBarTimer = Timer()
        guard let exportSessionUnwrapped = exportSession else { exportProgressBarTimer.invalidate()
            return
        }
        exportProgressBarTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
            let progress = Float((exportSessionUnwrapped.progress));
            let dict: [String: Float] = ["progress": progress]
        })
        
        guard let exportSession = exportSession else { exportProgressBarTimer.invalidate()
            return
        }
        
        exportSession.exportAsynchronously {
            exportProgressBarTimer.invalidate();
            switch exportSession.status {
            case .completed:
                DispatchQueue.main.async {
                    let dict : [String: Float] = ["progress": 1.0]
                    
                    onComplete(true, exportSession.outputURL)
                }
            case .failed:
                
                print("failed \(exportSession.error.debugDescription)")
                onComplete(false, nil)
                
            case .cancelled:
                
                print("cancelled \(exportSession.error.debugDescription)")
                onComplete(false, nil)
                
            default: break
            }
            
        }
    }
    
    func createOutputUrl(with videoUrl: URL) -> URL {
        let fileManager = FileManager.default
        let documentDirectory = NSURL.fileURL(withPath: NSTemporaryDirectory(), isDirectory: true)
        var outputUrl = documentDirectory.appendingPathComponent("output")
        
        do {
            try fileManager.createDirectory(at: outputUrl, withIntermediateDirectories: true)
            outputUrl = outputUrl.appendingPathExtension("\(videoUrl.lastPathComponent)")
        } catch let error {
            print("error")
            
        }
        return outputUrl
        
    }
    
    func merge(arrayVideo: [AVAsset]) -> AVMutableComposition {
        let mainCompisition = AVMutableComposition()
        
        let compositionVideoTrack = mainCompisition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        let compositionAudioTrack = mainCompisition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        let frontCamTransform: CGAffineTransform = CGAffineTransform(scaleX: -1.0, y: 1.0).rotated(by: CGFloat(Double.pi/2))
        let backCamTrasform: CGAffineTransform = CGAffineTransform(rotationAngle: .pi/2)
        
        compositionVideoTrack?.preferredTransform = backCamTrasform
        
        var insertTime = CMTime.zero
        for videoAsset in arrayVideo {
            try! compositionVideoTrack?.insertTimeRange(
                CMTimeRange(start: CMTime.zero, duration: videoAsset.duration),
                of: videoAsset.tracks(withMediaType: .video)[0],
                at: insertTime
            )
            
            if videoAsset.tracks(withMediaType: .audio).count > 0 {
                try! compositionAudioTrack?.insertTimeRange(
                    CMTimeRange(start: CMTime.zero, duration: videoAsset.duration),
                    of: videoAsset.tracks(withMediaType: .audio)[0],
                    at: insertTime
                )
                
                
                
            }
            insertTime = CMTimeAdd(insertTime, videoAsset.duration)
        }
        return mainCompisition
    }
}

func saveVideoToServer(sourceURL: URL, completion: ((_ outputUrl: URL) -> Void )? = nil) {
    
    let fileManager = FileManager.default
    
    let documentDirectory = NSURL.fileURL(withPath: NSTemporaryDirectory(), isDirectory: true)
    let asset = AVAsset(url: sourceURL)
    let length = Float(asset.duration.value) / Float(asset.duration.timescale)
    print("video: \(length) seconds")
    
    var outputURL = documentDirectory.appendingPathComponent("output")
    do {
        try fileManager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
        outputURL = outputURL.appendingPathComponent("\(sourceURL.lastPathComponent).mp4")
    }catch let error {
        print(error)
    }
    try? fileManager.removeItem(at: outputURL)
    
    guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {return}
    exportSession.outputURL = outputURL
    exportSession.outputFileType = AVFileType.mp4
    
    exportSession.exportAsynchronously {
        switch exportSession.status {
        case .completed:
            print("exported: \(outputURL)")
            completion?(outputURL)
        case .failed:
            print("failed")
        case .cancelled:
            print("cancelled")
            
        default: break
        }
    }
}
