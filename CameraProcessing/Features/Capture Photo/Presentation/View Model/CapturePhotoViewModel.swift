//
//  CameraViewModel.swift
//  CameraProcessing
//
//  Created by Johan Albrectsen on 06/10/2024.
//

import SwiftUI
import AVFoundation
import Swinject

class CapturePhotoViewModel: ObservableObject {
    
    //MARK: - Properties
    @Published var isPhotoDetailsPresented: Bool = false
    @Published var isPermissionDeniedPresented: Bool = false
    @Published var capturedPhoto: UIImage?
    @Published var isLoading: Bool = false
    @Published var videoPreviewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer()
    
    //MARK: - Init
    init() {
        setupVideoPreviewLayer()
    }
}

//MARK: - Dependancy injected Use Cases
extension CapturePhotoViewModel {
    
    private var requestCameraPermissionUseCase: RequestCameraPermissionUseCase {
        Container.shared.resolve(RequestCameraPermissionUseCase.self)!
    }
    
    private var capturePhotoUseCase: CapturePhotoUseCase {
        Container.shared.resolve(CapturePhotoUseCase.self)!
    }
    
    private var getVideoPreviewLayerUseCase: GetVideoPreviewLayerUseCase {
        Container.shared.resolve(GetVideoPreviewLayerUseCase.self)!
    }
    
    private var stopVideoSessionUseCase: StopVideoSessionUseCase {
        Container.shared.resolve(StopVideoSessionUseCase.self)!
    }
}

//MARK: - Methods
extension CapturePhotoViewModel {
    
    /// Captures the photo from the active capture session.
    func capture() async {
        // Start loading (main thread, due to property wrapper)
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        // Get the image from the capture session.
        let image = await capturePhotoUseCase.invoke()
        
        // Stop loading and set the captured image (main thread, due to property wrappers)
        DispatchQueue.main.async {
            if let image {
                self.capturedPhoto = image
                self.isPhotoDetailsPresented = true
            }
            self.isLoading = false
        }
    }
    
    /// Stops the active capture session.
    func stopSession() {
        stopVideoSessionUseCase.invoke()
    }
}

//MARK: - Internal methods
extension CapturePhotoViewModel {
    
    private func setupVideoPreviewLayer() {
        Task {
            // Check for permissions, if successful, proceed to get the video preview, if not, present the permission denied.
            guard
                await requestCameraPermissionUseCase.invoke()
            else {
                isPermissionDeniedPresented = true
                return
            }
            
            // Successfully got the permissions, setup the video preview layer.
            DispatchQueue.main.async {
                self.videoPreviewLayer = self.getVideoPreviewLayerUseCase.invoke()
            }
        }
    }
}
