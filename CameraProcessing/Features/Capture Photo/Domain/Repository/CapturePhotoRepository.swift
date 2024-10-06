//
//  CameraRepository.swift
//  CameraProcessing
//
//  Created by Johan Albrectsen on 06/10/2024.
//

import Foundation
import AVFoundation

// Alias used to describe the result of capturing and processing a photo.
typealias CapturePhotoAndHairMatteResult = (photo: Data?, hairMatte: Data?)

/// Interface for managing the business logic.
protocol CapturePhotoRepository {
    
    /// Requests for the camera permission if appropriate
    func requestMissingCameraPermissions() async -> Bool
    
    /// Gets the photo and hair mask image data.
    /// - Returns: A result containing the original and processed photo data.
    func getPhotoAndHairMatteData() async -> CapturePhotoAndHairMatteResult
    
    /// Gets the video preview layer for displaying camera stream.
    /// - Returns: The video preview layer used for to display camera stream.
    func getVideoPreviewLayer() -> AVCaptureVideoPreviewLayer
    
    /// Stops the active preview session.
    func stopVideoPreviewSession()
}
