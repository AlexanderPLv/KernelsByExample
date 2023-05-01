//
//  TextureProvider.swift
//  CIKernelExample
//
//  Created by Alexander Pelevinov on 01.05.2023.
//

import Metal
import UIKit

final class MetalTextureProvider {
    
    private let context: MetalContext
    
    init(context: MetalContext) {
        self.context = context
    }
    
    func textureForImage(
        _ image: UIImage,
        with context: MetalContext
    ) -> MTLTexture {
        if let cgImage = image.cgImage {
            cgImage.width
        }
                let width = image.size.width
        
    }
    
}
