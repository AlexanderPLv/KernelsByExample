//
//  CIKernelExampleApp.swift
//  CIKernelExample
//
//  Created by Alexander Pelevinov on 29.04.2023.
//

import SwiftUI

@main
struct CIKernelExampleApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(ImageProcessor())
        }
    }
}
