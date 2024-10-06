//
//  GetVideoPreviewLayerUseCase.swift
//  CameraProcessing
//
//  Created by Johan Albrectsen on 06/10/2024.
//

import Foundation
import AVFoundation

/// Gets the video preview layer used by the UI to display the video stream.
class GetVideoPreviewLayerUseCase {
    
    //MARK: - Properties
    private let capturePhotoRepository: CapturePhotoRepository
    
    //MARK: - Init
    init(capturePhotoRepository: CapturePhotoRepository) {
        self.capturePhotoRepository = capturePhotoRepository
    }
    
    //MARK: - Invoke
    func invoke() -> AVCaptureVideoPreviewLayer {
        return capturePhotoRepository.getVideoPreviewLayer()
    }
}
