//
//  ImageProcessor.swift
//  CIKernelExample
//
//  Created by Alexander Pelevinov on 29.04.2023.
//

import Combine
import CoreImage
import UIKit
import CoreImage.CIFilterBuiltins

final class ImageProcessor: ObservableObject {
    
    private let context = CIContext()
    private var bag = [AnyCancellable]()
    
    @Published var input: UIImage?
    @Published var output: UIImage?
    
    init() {
        $input
            .sink { [weak self] input in
                guard let input else { return }
                self?.filter(image: input)
            }.store(in: &bag)
    }
    
    private func renderAsUIImage(_ image: CIImage?) -> UIImage? {
        guard
            let image,
            let cgImage = context.createCGImage(image, from: image.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
    
    private func filter(image: UIImage) {
        let filter = CIFilter.comicEffect()
        let options = [CIImageOption.applyOrientationProperty: true]
        let ciImage = CIImage(image: image, options: options)
        filter.inputImage = ciImage
        guard let filtered = renderAsUIImage(filter.outputImage) else { output = image; return }
        DispatchQueue.main.async{
            self.output = filtered
        }
    }
}

enum Filter: String {
    case bilateral = "bilateralFilterKernel"
}
