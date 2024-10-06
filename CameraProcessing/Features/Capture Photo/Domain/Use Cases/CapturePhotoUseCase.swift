//
//  CapturePhotoUseCase.swift
//  CameraProcessing
//
//  Created by Johan Albrectsen on 06/10/2024.
//

import UIKit

/// Use case used get the appropriate photo from active capture session and return to the view model
class CapturePhotoUseCase {
 
    // MARK: - Properties
    private let capturePhotoRepository: CapturePhotoRepository
    
    //MARK: - Init
    init(capturePhotoRepository: CapturePhotoRepository) {
        self.capturePhotoRepository = capturePhotoRepository
    }
    
    //MARK: - Invoke
    func invoke() async -> UIImage? {
        let result = await capturePhotoRepository.getPhotoAndHairMatteData()
        
        // Check of the processed hair matte photo is available and return if the case.
        if
            let hairMatteImageData = result.hairMatte,
            let hairMatteImage = UIImage(data: hairMatteImageData)
        {
            return hairMatteImage
        }
        // In case the hair matte procesesd photo is not available, we'll fall back on the primitive unprocessed image data.
        else if
            let imageData = result.photo,
            let image = UIImage(data: imageData)
        {
            return image
        } else {
            return nil
        }
    }
}
