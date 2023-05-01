//
//  MyKernels.ci.metal
//  CIKernelExample
//
//  Created by Alexander Pelevinov on 29.04.2023.
//

#include <metal_stdlib>
using namespace metal;

#include <CoreImage/CoreImage.h>
#include <metal_stdlib>
using namespace metal;

#define K_R 0.2126
#define K_G 0.7152
#define K_B 0.0722

extern "C" {
    namespace coreimage {
        float4 passthroughFilterKernel(sample_t s) {
            return s;
        }
    }
}

//MARK: -YCbCr to RGB
extern "C" {
    namespace coreimage {
        
        float4 ycbcrToRgb(float4 pixel) {
          float y  = pixel.r;
          float cb = pixel.g;
          float cr = pixel.b;
          float blue  = 2 * cb * (1 - K_B) + y;
          float red   = 2 * cr * (1 - K_R) + y;
          float green = (y - K_R * red - K_B * blue) / K_G;
          return float4(red, green, blue, pixel.a);
        }
        
        float intensity(float4 pixel) {
            return K_R * pixel.r + K_G * pixel.g + K_B * pixel.b;
        }
        
        float blueDifference(float4 pixel) {
            return (pixel.b - intensity(pixel)) / (2 * (1 - K_B));
        }
                                                  
        float redDifference(float4 pixel) {
            return (pixel.r - intensity(pixel)) / (2 * (1 - K_R));
        }
        
        float4 rgbToYcbcrFilterKernel(sample_t s) {
            float y = intensity(s);
            float cb = blueDifference(s);
            float cr = redDifference(s);
            return float4(y, cb ,cr, s.a);
        }
    }
}

//MARK: - bilateral filter
extern "C" {
    namespace coreimage {
        
        float4 bilateralFilterKernel(sampler src, float kernelRadius_f, float sigmaSpatial, float sigmaRange) {
            float4 input = src.sample(src.coord());
            float3 premultipliedRunningSum = 0;
            float weightRunningSum = 0;
            int kernelRadius = int(kernelRadius_f);
            
            for (int i = -kernelRadius; i<= kernelRadius; i++) {
                for (int j = -kernelRadius; j <= kernelRadius; j++) {
                    float4 referenceInput = src.sample(src.coord() + float2(i, j) / src.size());
                    float weight = exp ( - (i * i + j * j) / (2 * sigmaSpatial * sigmaSpatial)
                                         - pow((input.r - referenceInput.r), 2.0) / (2 * sigmaRange * sigmaRange));
                    weightRunningSum += weight;
                    premultipliedRunningSum += weight * referenceInput.rgb;
                }
            }
            return float4(premultipliedRunningSum / weightRunningSum, input.a);
        }
        
    }
}
