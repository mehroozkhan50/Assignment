//
//  FilterViewCell.swift
//  Assignment
//
//  Created by Mehrooz khan on 7/8/23.
//

import UIKit
import GPUImage

class FilterViewCell: UICollectionViewCell {
    @IBOutlet weak var sourceImageView: UIImageView!
    @IBOutlet weak var filterName: UILabel!
    var sourceImg : UIImage!
    var filtertext : String!
    var filter : filters!
    
    func setupUI(){
        if sourceImg != nil {
            sourceImageView.image = sourceImg
            
            // Apply the selected filter to the image
            if let metalShaderName = getMetalShaderName(for: filter) {
//                let filter = CustomFilter(metalShaderName: metalShaderName)
//                let gpuImagePicture = GPUImagePicture(image: sourceImg)
//                gpuImagePicture?.addTarget(filter)
//                filter.useNextFrameForImageCapture()
//                gpuImagePicture?.processImage()
//                let filteredImage = filter.imageFromCurrentFramebuffer()
                switch filter{
                case .Amaro:
                    let blurFilter = GPUImageGrayscaleFilter()
                    
                    let outputImage = blurFilter.image(byFilteringImage: sourceImg)
                    sourceImageView.image = outputImage
                    self.filterName.text = "Grey"
                case .none:
                    let blurFilter = GPUImageGaussianBlurFilter()
                    blurFilter.blurRadiusInPixels = 10
                    
                    let outputImage = blurFilter.image(byFilteringImage: sourceImg)
                    sourceImageView.image = outputImage
                case .some(.Char):
                    let blurFilter = GPUImageSwirlFilter()
                    
                    let outputImage = blurFilter.image(byFilteringImage: sourceImg)
                    sourceImageView.image = outputImage
                    self.filterName.text = "Swirl"
                case .some(.Dawn):
                    let blurFilter = GPUImageThresholdSketchFilter()
                    
                    let outputImage = blurFilter.image(byFilteringImage: sourceImg)
                    sourceImageView.image = outputImage
                    self.filterName.text = "Sketch"
                case .some(.Gold):
                    let blurFilter = GPUImageBrightnessFilter()
                    
                    let outputImage = blurFilter.image(byFilteringImage: sourceImg)
                    sourceImageView.image = outputImage
                    self.filterName.text = "Bright"
                case .some(.Willow):
                    let blurFilter = GPUImageRGBFilter()
                    blurFilter.blue = 0.7
                    blurFilter.green = 0.4
                    blurFilter.red = 0.6
                    let outputImage = blurFilter.image(byFilteringImage: sourceImg)
                    sourceImageView.image = outputImage
                    self.filterName.text = "RGB"
                }
                
            }
        }
        
    }
    func getMetalShaderName(for filterType: filters) -> String? {
            switch filterType {
            case .Amaro:
                return "Amaro.metal"
            case .Char:
                return "Char.metal"
            case .Dawn:
                return "Dawn.metal"
            case .Gold:
                return "Gold.metal"
            case .Willow:
                return "Willow.metal"
            }
        }
}
