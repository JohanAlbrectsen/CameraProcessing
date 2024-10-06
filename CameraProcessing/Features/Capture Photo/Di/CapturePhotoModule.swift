//
//  CapturePhotoModule.swift
//  CameraProcessing
//
//  Created by Johan Albrectsen on 06/10/2024.
//

import Foundation
import Swinject

/// Manages the dependancies of the Capture Photo feature.
class CapturePhotoModule {
    
    private let container = Container.shared
    
    /// Registers the dependancy injection objects
    func register() {
        provideCameraPermissionManager()
        provideCapturePhotoRepository()
        provideCapturePhotoUseCase()
        provideGetVideoPreviewLayerUseCase()
        provideRequestCameraPermissionUseCase()
        provideStopVideoSessionUseCase()
    }
    
    /// Provides the camera permission manager.
    func provideCameraPermissionManager() {
        container.register(CameraPermissionManager.self) { _ in
            return CameraPermissionManager()
        }
    }
    
    /// Provides the Capture Photo repository
    func provideCapturePhotoRepository() {
        container.register(CapturePhotoRepository.self) { resolver in
            let cameraPermissionManager = resolver.resolve(CameraPermissionManager.self)!
            
            return CapturePhotoRepositoryImpl(
                cameraManager: CameraManager.shared,
                cameraPermissionManager: cameraPermissionManager
            )
        }
    }
    
    /// Provides the Capture Photo use case, used when capturing a photo.
    func provideCapturePhotoUseCase() {
        container.register(CapturePhotoUseCase.self) { resolver in
            let capturePhotoRepository = resolver.resolve(CapturePhotoRepository.self)!
            return CapturePhotoUseCase(capturePhotoRepository: capturePhotoRepository)
        }
    }
    
    /// Provides the get video preview layer use case, used when displaying the camera stream.
    func provideGetVideoPreviewLayerUseCase() {
        container.register(GetVideoPreviewLayerUseCase.self) { resolver in
            let capturePhotoRepository = resolver.resolve(CapturePhotoRepository.self)!
            return GetVideoPreviewLayerUseCase(capturePhotoRepository: capturePhotoRepository)
        }
    }
    
    func provideRequestCameraPermissionUseCase() {
        container.register(RequestCameraPermissionUseCase.self) { resolver in
            let capturePhotoRepository = resolver.resolve(CapturePhotoRepository.self)!
            return RequestCameraPermissionUseCase(capturePhotoRepository: capturePhotoRepository)
        }
    }
    
    /// Provides the Stop Video Preview session use case, used when stopping the camera stream.
    func provideStopVideoSessionUseCase() {
        container.register(StopVideoSessionUseCase.self) { resolver in
            let capturePhotoRepository = resolver.resolve(CapturePhotoRepository.self)!
            return StopVideoSessionUseCase(capturePhotoRepository: capturePhotoRepository)
        }
    }
}
