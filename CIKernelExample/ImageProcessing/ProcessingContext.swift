//
//  ProcessingContext.swift
//  CIKernelExample
//
//  Created by Alexander Pelevinov on 01.05.2023.
//

import Metal

final class MetalContext: ProcessingContext {
    
    let device: MTLDevice
    let library: MTLLibrary
    let commandQueue: MTLCommandQueue
    
    init(device: MTLDevice) {
        self.device = device
        guard let library = device.makeDefaultLibrary() else {
            fatalError("Enable to create MetalContext Library.")
        }
        self.library = library
        guard let queue = device.makeCommandQueue() else {
            fatalError("Enable to create MetalContext CommandQueue.")
        }
        self.commandQueue = queue
    }
}
