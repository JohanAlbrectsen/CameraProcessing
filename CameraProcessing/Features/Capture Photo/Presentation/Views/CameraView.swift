//
//  CameraSessionView.swift
//  CameraProcessing
//
//  Created by Johan Albrectsen on 06/10/2024.
//

import SwiftUI
import UIKit
import AVFoundation

/// The camera view used to wrap the UIKit `CameraUIView` displaying the video preview layer.
struct CameraView: UIViewRepresentable {
    
    //MARK: - Properties
    let videoPreviewLayer: AVCaptureVideoPreviewLayer
}

//MARK: - UIViewRepresentable methods.
extension CameraView {
    
    func makeUIView(context: Context) -> CameraUIView {
        let view = CameraUIView(videoPreviewLayer: videoPreviewLayer)
        return view
    }
    
    func updateUIView(_ uiView: CameraUIView, context: Context) {
        uiView.videoPreviewLayer = videoPreviewLayer
        uiView.layoutSubviews()
    }
}
