//
//  CameraUIView.swift
//  CameraProcessing
//
//  Created by Johan Albrectsen on 06/10/2024.
//

import UIKit
import AVFoundation

/// The UIKit view used to display the video preview layer.
class CameraUIView: UIView {
    
    //MARK: - Properties
    var videoPreviewLayer: AVCaptureVideoPreviewLayer
    
    //MARK: - Init
    init(videoPreviewLayer: AVCaptureVideoPreviewLayer) {
        self.videoPreviewLayer = videoPreviewLayer
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Override methods
extension CameraUIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        videoPreviewLayer.removeFromSuperlayer()
        
        videoPreviewLayer.frame = bounds
        layer.addSublayer(videoPreviewLayer)
    }
}
