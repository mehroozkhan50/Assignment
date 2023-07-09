//
//  CustomFilters.swift
//  Assignment
//
//  Created by Mehrooz khan on 7/8/23.
//

import Foundation
import GPUImage
import Metal

class CustomFilter: GPUImageFilterGroup {
    let metalShaderName: String
    
    init(metalShaderName: String) {
        self.metalShaderName = metalShaderName
        super.init()
        print("shaders :\(metalShaderName)")
        let filter = GPUImageFilter(vertexShaderFrom: nil, fragmentShaderFrom: metalShaderName)
        addFilter(filter)
        
        let terminalFilter = filter
        initialFilters = [filter]
        //terminalFilter?.addTarget(outputFramebuffer())
        
//        initialFilters = [filter]
//        terminalFilter?.addTarget(outputFramebuffer)
    }
}
