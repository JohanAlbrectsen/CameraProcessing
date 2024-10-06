//
//  CameraProcessor.swift
//  CameraProcessing
//
//  Created by Johan Albrectsen on 06/10/2024.
//

import Foundation
import AVFoundation
import UIKit

protocol CameraProcessorDelegate: AnyObject {
    func didFinishProcessingPhoto(_ photoData: Data?, _ maskData: Data?)
}

class CameraProcessor: NSObject, AVCapturePhotoCaptureDelegate {
    
    weak var delegate: CameraProcessorDelegate?
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: (any Error)?) {
        if error != nil {
            delegate?.didFinishProcessingPhoto(nil, nil)
        }
        
        guard
            let imageData = getImageData(photo: photo)
        else {
            delegate?.didFinishProcessingPhoto(nil, nil)
            return
        }
        
        guard
            let hairMatteData = getHairMatteImageData(photo: photo)
        else {
            delegate?.didFinishProcessingPhoto(imageData, nil)
            return
        }
        
        delegate?.didFinishProcessingPhoto(imageData, hairMatteData)
    }
    
    private func getImageData(photo: AVCapturePhoto) -> Data? {
        guard
            let cgImage = photo.cgImageRepresentation()
        else {
            return nil
        }
        
        var rotatedImage = CIImage(cgImage: cgImage)
            rotatedImage = rotatedImage.oriented(.right)
        
        let uiImage = UIImage(ciImage: rotatedImage)
        
        let jpegData = uiImage.jpegData(compressionQuality: 0.5)
        
        guard jpegData != nil else {
            return nil
        }
        
        return jpegData
    }
    
    private func getHairMatteImageData(photo: AVCapturePhoto) -> Data? {
        guard
            let hairMatte = photo.semanticSegmentationMatte(for: .hair)
        else {
            return nil
        }
        
        var ciHairMatteImage = CIImage(cvPixelBuffer: hairMatte.mattingImage)
            ciHairMatteImage = ciHairMatteImage.oriented(.right)
        
        let hairMatteUIImage = UIImage(ciImage: ciHairMatteImage)
        
        guard
            let hairMatteJPGData = hairMatteUIImage.jpegData(compressionQuality: 0.5)
        else { return nil }
        
        return hairMatteJPGData
    }
}
