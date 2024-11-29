//
//  ProgressView.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 23.08.2024.
//

import UIKit

class ProgressView : UIView {
    
    required init(width: CGFloat) {
        self.width = width
        super.init(frame: CGRect.zero)
        DrawPaths()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let width : CGFloat
    var aPath: UIBezierPath = UIBezierPath()
    var segments = [UIView]()
    var segPoints = [CFloat]()
    
    let shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor(red: 14/255, green: 173/255, blue: 255/255, alpha: 1.0).cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = .round
        return shapeLayer
    }()
    
    fileprivate let trackLayer: CAShapeLayer = {
        let trackerLayer = CAShapeLayer()
        trackerLayer.strokeColor = UIColor.darkGray.withAlphaComponent(0.2).cgColor
        trackerLayer.lineWidth = 4
        trackerLayer.strokeEnd = 1
        trackerLayer.lineCap = .round
        return trackerLayer
    }()
    
    fileprivate func DrawPaths(){
        aPath.move(to: CGPoint(x: 0.0, y: 0.0))
        aPath.addLine(to: CGPoint(x: width, y: 0.0))
        aPath.move(to: CGPoint(x: 0.0, y: 0.0))
        aPath.close()
        setupTrackLayer()
        setupShapeLayer()
    }
    fileprivate func setupTrackLayer(){
        trackLayer.path = aPath.cgPath
        layer.addSublayer(trackLayer)
    }
    fileprivate func setupShapeLayer(){
        shapeLayer.path = aPath.cgPath
        layer.addSublayer(shapeLayer)
    }
    func setProgress(_ progress: CGFloat){
        shapeLayer.strokeEnd = progress
    }
    
    func pauseProgress(){
        let newSegment = createSegment()
        addSubview(newSegment)
        newSegment.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -2).isActive = true
        positionSegment(newSegment: newSegment)
        segments.append(newSegment)
        segPoints.append(CFloat(shapeLayer.strokeEnd))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.positionSegment(newSegment: newSegment)
        }
        
        
    }
    
    func createSegment() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 4).isActive = true
        view.heightAnchor.constraint(equalToConstant: 4).isActive = true
        return view
        
    }
    func positionSegment(newSegment: UIView){
        let positionPath = CGPoint(x: shapeLayer.strokeEnd * frame.width, y: 0)
        newSegment.constraintToLEft(paddingLeft: positionPath.x)
        newSegment.backgroundColor = UIColor.darkGray
        print("segments:", segments.count)
        
    }
    func removeLastSegment(){
        segments.last?.removeFromSuperview()
        segPoints.removeLast()
        segments.removeLast()
        shapeLayer.strokeEnd = CGFloat(segPoints.last ?? 0)
        print("segment:", segments.count)
    }
}

extension UIView {
    func constraintToLEft(paddingLeft: CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        if let left = superview?.leftAnchor {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
    }
}
