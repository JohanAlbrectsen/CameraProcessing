//
//  ContentView.swift
//  CameraProcessing
//
//  Created by Johan Albrectsen on 06/10/2024.
//

import SwiftUI
import UIKit
import AVFoundation

struct CapturePhotoView: View {
    
    //MARK: - Properties
    @ObservedObject var viewModel = CapturePhotoViewModel()
}

//MARK: - Body
extension CapturePhotoView {
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                cameraSessionView
                captureButton
            }
            .navigationDestination(isPresented: $viewModel.isPhotoDetailsPresented) {
                ViewImageView(image: viewModel.capturedPhoto)
            }
            .navigationDestination(isPresented: $viewModel.isPermissionDeniedPresented) {
                Text("Permissions missing")
            }
        }
    }
}

//MARK: - Subviews
extension CapturePhotoView {
    
    @ViewBuilder
    private var cameraSessionView: some View {
        CameraView(
            videoPreviewLayer: viewModel.videoPreviewLayer
        )
            .ignoresSafeArea()
    }
    
    @ViewBuilder
    private var captureButton: some View {
        Button {
            capturePicture()
        } label: {
            if viewModel.isLoading {
                ProgressView()
                    .tint(Color.white)
                    .frame(maxWidth: .infinity)
            } else {
                Text("Capture")
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 17)
                .frame(height: 59)
                .foregroundStyle(Color.blue)
        )
        .frame(height: 59)
        .padding(.horizontal, 24)
    }
}

//MARK: - Methods
extension CapturePhotoView {
    
    func capturePicture() {
        Task {
            await viewModel.capture()
        }
    }
}
