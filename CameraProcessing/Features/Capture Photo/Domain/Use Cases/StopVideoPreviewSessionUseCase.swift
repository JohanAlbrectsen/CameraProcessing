//
//  StopVideoSessionUseCase.swift
//  CameraProcessing
//
//  Created by Johan Albrectsen on 06/10/2024.
//

import Foundation

/// Stops the active video capturing session.
class StopVideoSessionUseCase {
    
    //MARK: - Properties
    private let capturePhotoRepository: CapturePhotoRepository
    
    //MARK: - Init
    init(capturePhotoRepository: CapturePhotoRepository) {
        self.capturePhotoRepository = capturePhotoRepository
    }
    
    //MARK: - Invoke
    func invoke() {
        capturePhotoRepository.stopVideoPreviewSession()
    }
}
