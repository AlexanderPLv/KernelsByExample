//
//  FiltersService.swift
//  CIKernelExample
//
//  Created by Alexander Pelevinov on 29.04.2023.
//

import CoreImage

class BilateralFilter: CIFilter {
  private lazy var kernel: CIKernel = {
    guard
      let url = Bundle.main.url(forResource: "MyKernels", withExtension: "ci.metallib"),
      let data = try? Data(contentsOf: url) else {
        fatalError("Unable to load metallib")
    }
    
    guard let kernel = try? CIKernel(functionName: "bilateralFilterKernel", fromMetalLibraryData: data) else {
      fatalError("Unable to load bilateralFilterKernel")
    }
    
    return kernel
  }()
  
  var inputImage: CIImage?
  var kernelRadius: Float = 13
  var sigmaSpatial: Float = 15
  var sigmaRange: Float = 0.1
  
  override var outputImage: CIImage? {
    guard let inputImage = inputImage else { return .none }
    
    return kernel.apply(extent: inputImage.extent,
                        roiCallback: { (index, rect) -> CGRect in
                          let out = rect.insetBy(dx: CGFloat(-self.kernelRadius), dy: CGFloat(-self.kernelRadius)).intersection(inputImage.extent)
                          return out
    },
                        arguments: [inputImage, kernelRadius, sigmaSpatial, sigmaRange])
  }
}

class RgbToYcbcrFilterKernel: CIFilter {
    private lazy var kernel: CIKernel = {
        
        guard let url = Bundle.main.url(forResource: "MyKernels", withExtension: "ci.metallib"),
              let data = try? Data(contentsOf: url) else {
            fatalError("Unable to load metallib")
        }
        
        guard let kernel = try? CIColorKernel(
            functionName: "rgbToYcbcrFilterKernel",
            fromMetalLibraryData: data
        ) else {
            fatalError("Unable to create the ColorKernel for passthroughFilterKL")
        }
        return kernel
    }()
    
    var inputImage: CIImage?
    
    override var outputImage: CIImage? {
        guard let inputImage else { return nil }
        
        return kernel.apply(
            extent: inputImage.extent,
            roiCallback: { _, rect in
            return rect
        },
            arguments: [inputImage])
    }
    
}

class YcbcrToRgb: CIFilter {
    private lazy var kernel: CIKernel = {
        
        guard let url = Bundle.main.url(forResource: "MyKernels", withExtension: "ci.metallib"),
              let data = try? Data(contentsOf: url) else {
            fatalError("Unable to load metallib")
        }
        
        guard let kernel = try? CIColorKernel(
            functionName: "ycbcrToRgb",
            fromMetalLibraryData: data
        ) else {
            fatalError("Unable to create the ColorKernel for passthroughFilterKL")
        }
        return kernel
    }()
    
    var inputImage: CIImage?
    
    override var outputImage: CIImage? {
        guard let inputImage else { return nil }
        
        return kernel.apply(
            extent: inputImage.extent,
            roiCallback: { _, rect in
            return rect
        },
            arguments: [inputImage])
    }
    
}
