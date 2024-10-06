//
//  CameraPermissionManager.swift
//  CameraProcessing
//
//  Created by Johan Albrectsen on 06/10/2024.
//

import Foundation
import AVFoundation

/// Manages the permissions for the camera.
class CameraPermissionManager {
    
    /// Gets the current permission status.
    /// - Returns: The `Bool` indicating whether or not the user has granted authorization.
    func getIsPermissionGranted() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }
    
    /// Requests permission for the camera.
    /// - Returns: The `Bool` indicating whether or not the user granted authorization.
    func requestPermission() async -> Bool {
        return await AVCaptureDevice.requestAccess(for: .video)
    }
}
