//
//  ViewImageView.swift
//  CameraProcessing
//
//  Created by Johan Albrectsen on 06/10/2024.
//

import SwiftUI

struct ViewImageView: View {
    
    //MARK: - Properties
    let image: UIImage?
    
    //MARK: - Init
    init(image: UIImage?) {
        self.image = image
    }
}

//MARK: - Body
extension ViewImageView {
    
    var body: some View {
        ZStack {
            if let image {
                Image(uiImage: image)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )
            } else {
                Text("Image data invalid")
            }
        }
    }
}
