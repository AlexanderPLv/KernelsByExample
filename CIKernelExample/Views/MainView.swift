//
//  MainView.swift
//  CIKernelExample
//
//  Created by Alexander Pelevinov on 30.04.2023.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject private var imageProcessor: ImageProcessor
    
    private var showingImage: Bool {
     image != nil
    }
    
    @State private var showingPicker = false
    @State private var image: Image?
  //  @State private var inputImage: UIImage?
  //  @State private var processedImage: UIImage?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                if !showingImage {
                    Button {
                        openPicker()
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .tint(.gray)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(.gray, lineWidth: 3)
                            )
                    }
                    .frame(width: 100, height: 100, alignment: .center)
                } else {
                    VStack {
                        image?
                            .resizable()
                            .scaledToFit()
                            .padding(.vertical)
                        HStack {
                            Button("Change") {
                                openPicker()
                            }
                            Spacer()
                            Button("Save") {
                                
                            }
                        }
                        .tint(.white)
                        .padding(.horizontal)
                    }
                }
            }
            .onChange(of: imageProcessor.output) { image in
                handleImage(image)
            }
            .sheet(isPresented: $showingPicker) {
                MediaPicker(image: $imageProcessor.input)
            }
            
        }
    }
    
    private func handleImage(_ image: UIImage?) {
        guard let image else { return }
        self.image = Image(uiImage: image)
    }
    
    private func openPicker() {
        showingPicker = true
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
