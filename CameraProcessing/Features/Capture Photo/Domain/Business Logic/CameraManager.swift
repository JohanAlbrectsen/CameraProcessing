//
//  CameraManager.swift
//  CameraProcessing
//
//  Created by Johan Albrectsen on 06/10/2024.
//

import AVFoundation
import UIKit

class CameraManager: NSObject {
    
    /// The capturing session used by the preview layer and to capture photos.
    private var captureSession: AVCaptureSession
    
    /// The output used by the capture session to export frame as photo.
    private var stillImageOutput: AVCapturePhotoOutput
    
    /// Capturing device. Currently using the standard video device, specific camera device can be specified by need.
    private var device: AVCaptureDevice?
    
    /// Video preview layer, used to display the video stream.
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer
    
    /// Camera processor, uses the captured photo and processes with potential hair matte data as output.
    private var cameraProcessor = CameraProcessor()
    
    /// Capture completion, used to bind delegate callbacks in a unified async method for capturing photos.
    private var captureBlock: ((_ photoData: Data?, _ maskData: Data?) -> Void)?
    
    /// As the camera manager handles the capturing session, we want to continuously keep the same object in memory.
    static let shared = CameraManager()
    
    override init() {
        // Configure capturing session
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        // Configure still image output.
        stillImageOutput = AVCapturePhotoOutput()
        stillImageOutput.maxPhotoQualityPrioritization = .speed
        
        // Configure video preview layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        super.init()
        
        cameraProcessor.delegate = self
        try? configure()
    }
}

//MARK: - Methods accessed by the repository or other parent object.
extension CameraManager {
    
    /// Accesses and returns the video preview layer, used for displaying the video stream.
    /// - Returns: The video preview layer, used for displaying the video stream.
    func getPreviewLayer() -> AVCaptureVideoPreviewLayer {
        
        // We check whether or not there's an active connection, if so, we'll make sure the video rotation angle is correct (portrait).
        if videoPreviewLayer.connection != nil {
            videoPreviewLayer.connection?.videoRotationAngle = getRotationAngle()
        }
        videoPreviewLayer.videoGravity = .resizeAspectFill
        
        return videoPreviewLayer
    }
    
    /// Starts the capure session. Has to be done on the background thread.
    func startSession() {
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }
    
    /// Stops the running capture session.
    func stopSession() {
        captureSession.stopRunning()
    }
    
    /// Uses the active capture session to capture a picture, which will then be processed by the CameraProcessor and finally returned.
    /// - Returns: The result, containing the photo data and processed photo data.
    func capturePhoto() async -> CapturePhotoAndHairMatteResult {
        return await withCheckedContinuation { (continuation: CheckedContinuation<CapturePhotoAndHairMatteResult, Never>) in
            
            // Setup the capture block, which will trigger the `capturePhoto` to proceed using `continuation.resume(...)`
            captureBlock = { image, maskData in
                let result = CapturePhotoAndHairMatteResult(image, maskData)
                continuation.resume(returning: result)
            }
            
            // Configure the settings for the capturing of the photo.
            let format: [String: Any] = [
                String(kCVPixelBufferPixelFormatTypeKey): kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
            ]
                
            let settings = AVCapturePhotoSettings(format: format)
                settings.isPortraitEffectsMatteDeliveryEnabled = stillImageOutput.isPortraitEffectsMatteDeliveryEnabled
                settings.enabledSemanticSegmentationMatteTypes = stillImageOutput.availableSemanticSegmentationMatteTypes
            
            // Capture the photo, will trigger the camera processor, which will return the image and processed image data.
            stillImageOutput.capturePhoto(with: settings, delegate: cameraProcessor)
        }
    }
}

//MARK: - Helper methods.
extension CameraManager {
    
    /// Configures the device, capturing session and still image output.
    private func configure() throws {
        //Access the built in camera
        device = AVCaptureDevice.default(for: .video)
        guard
            let device = device
        else { return }
        
        // Create input object and ensure the capture session is capable of adding it
        let input = try AVCaptureDeviceInput(device: device)
        guard captureSession.canAddInput(input) else { return }
        
        // Add input / output to the capture session and commit the configuration.
        captureSession.addInput(input)
        captureSession.addOutput(stillImageOutput)
        captureSession.commitConfiguration()
        
        //Enable depth data and semantic segmentation
        if stillImageOutput.isDepthDataDeliverySupported {
            stillImageOutput.isDepthDataDeliveryEnabled = true
        }
        
        // Enable matte effets for the still image output, which will later be processed
        if stillImageOutput.isPortraitEffectsMatteDeliverySupported {
            stillImageOutput.isPortraitEffectsMatteDeliveryEnabled = true
        }
    }
    
    /// Calculates (using system APIs) the portrait rotation angle for the video preview layer.
    /// - Returns: Portrait rotation angle for video preview layer.
    private func getRotationAngle() -> CGFloat {
        guard let device = device else { return 0 }
        
        let rotationCoordiantor = AVCaptureDevice.RotationCoordinator(
            device: device,
            previewLayer: nil
        )
        
        return rotationCoordiantor.videoRotationAngleForHorizonLevelCapture
    }
}

extension CameraManager: CameraProcessorDelegate {
    
    func didFinishProcessingPhoto(_ photoData: Data?, _ maskData: Data?) {
        //Run the capture block, which is observed by `func capturePhoto() async` and will cause it to compelte and return the result.
        captureBlock?(photoData, maskData)
    }
}
