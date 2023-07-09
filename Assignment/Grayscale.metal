//
//  
//  Assignment
//
//  Created by Mehrooz khan on 7/8/23.
//


#include <metal_stdlib>

using namespace metal;

//// Define the function to apply the grayscale effect
//float4 grayscaleFilter(fragment float4 color [[stage_in]]) {
//    float luminance = dot(color.rgb, float3(0.2126, 0.7152, 0.0722));
//    return float4(luminance, luminance, luminance, color.a);
//}
//
//// The entry point for the fragment shader
//fragment float4 grayscaleFilterFragmentShader(VertexOut vertexOut [[stage_in]]) {
//    return grayscaleFilter(vertexOut.color);
//}
