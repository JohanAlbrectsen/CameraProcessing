//
//  CameraProcessingApp.swift
//  CameraProcessing
//
//  Created by Johan Albrectsen on 06/10/2024.
//

import SwiftUI
import SwiftData

@main
struct CameraProcessingApp: App {

    init() {
        let capturePhotoModule = CapturePhotoModule()
            capturePhotoModule.register()
    }
    
    var body: some Scene {
        WindowGroup {
            CapturePhotoView()
        }
    }
}
