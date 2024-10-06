//
//  CapturePhotoRepositoryImpl.swift
//  CameraProcessing
//
//  Created by Johan Albrectsen on 06/10/2024.
//

import Foundation
import AVFoundation

class CapturePhotoRepositoryImpl: CapturePhotoRepository {
    
    //MARK: - Properties
    private let cameraManager: CameraManager
    private let cameraPermissionManager: CameraPermissionManager
    
    //MARK: - Init
    init(cameraManager: CameraManager, cameraPermissionManager: CameraPermissionManager) {
        self.cameraManager = cameraManager
        self.cameraPermissionManager = cameraPermissionManager
    }
    
    //MARK: - Methods
    func requestMissingCameraPermissions() async -> Bool {
        if !cameraPermissionManager.getIsPermissionGranted() {
            return await cameraPermissionManager.requestPermission()
        }
        
        return cameraPermissionManager.getIsPermissionGranted()
    }
    
    func getPhotoAndHairMatteData() async -> CapturePhotoAndHairMatteResult {
        await cameraManager
            .capturePhoto()
    }
    
    func getVideoPreviewLayer() -> AVCaptureVideoPreviewLayer {
        cameraManager
            .startSession()
        
        return cameraManager
            .getPreviewLayer()
    }
    
    func stopVideoPreviewSession() {
        cameraManager
            .stopSession()
    }
}
