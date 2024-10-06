//
//  RequestCameraPermissionUseCase.swift
//  CameraProcessing
//
//  Created by Johan Albrectsen on 06/10/2024.
//

/// Requests for camera permission if it's not already granted.
class RequestCameraPermissionUseCase {
    
    //MARK: - Properties
    private let capturePhotoRepository: CapturePhotoRepository
    
    //MARK: - Init
    init(capturePhotoRepository: CapturePhotoRepository) {
        self.capturePhotoRepository = capturePhotoRepository
    }
    
    //MARK: - Invoke
    func invoke() async -> Bool {
        return await capturePhotoRepository
            .requestMissingCameraPermissions()
    }
}
