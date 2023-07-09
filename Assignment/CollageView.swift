//
//  CollageView.swift
//  Assignment
//
//  Created by Mehrooz khan on 7/8/23.
//

import UIKit

enum CollageType {
    case collage1
    case collage2
}

class CollageView: UIView {
    var currentCollageType: CollageType = .collage1
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let path = createCollagePath()
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.lightGray.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 2.0
        layer.addSublayer(shapeLayer)
    }
    
    func createCollagePath() -> UIBezierPath {
        let path = UIBezierPath()
        
        switch currentCollageType {
        case .collage1:
            let rect1 = CGRect(x: 10, y: 10, width: bounds.width/2 - 20, height: bounds.height/2 - 20)
            path.append(UIBezierPath(rect: rect1))
            
            let rect2 = CGRect(x: bounds.width/2 + 10, y: 10, width: bounds.width/2 - 20, height: bounds.height/2 - 20)
            path.append(UIBezierPath(rect: rect2))
            
            let rect3 = CGRect(x: 10, y: bounds.height/2 + 10, width: bounds.width - 20, height: bounds.height/2 - 20)
            path.append(UIBezierPath(rect: rect3))
            
        case .collage2:
            let rect1 = CGRect(x: 10, y: 10, width: bounds.width/3 - 20, height: bounds.height - 20)
            path.append(UIBezierPath(rect: rect1))
            
            let rect2 = CGRect(x: bounds.width/3 + 10, y: 10, width: bounds.width/3 - 20, height: bounds.height - 20)
            path.append(UIBezierPath(rect: rect2))
            
            let rect3 = CGRect(x: (bounds.width/3)*2 + 10, y: 10, width: bounds.width/3 - 20, height: bounds.height - 20)
            path.append(UIBezierPath(rect: rect3))
        }
        
        return path
    }
    
    func drawSliceInView(view: CollageView, startAngle: CGFloat, endAngle: CGFloat, radius: CGFloat, image: UIImage) {
        let path = UIBezierPath()
        
        // Define the shape of the slice using custom points
        path.move(to: CGPoint(x: view.bounds.width * 0.2, y: view.bounds.height))
        path.addLine(to: CGPoint(x: 0, y: view.bounds.height * 0.7))
        path.addLine(to: CGPoint(x: view.bounds.width * 0.3, y: view.bounds.height * 0.4))
        path.addLine(to: CGPoint(x: view.bounds.width, y: view.bounds.height * 0.6))
        path.addLine(to: CGPoint(x: view.bounds.width * 0.8, y: view.bounds.height))
        path.close()
        
        // Create the shape layer and configure its properties
        let sliceLayer = CAShapeLayer()
        sliceLayer.path = path.cgPath
        sliceLayer.fillColor = UIColor.blue.cgColor
        sliceLayer.backgroundColor = nil
        sliceLayer.strokeColor = UIColor.white.cgColor
        sliceLayer.lineWidth = 2.0
        
        // Create an image view with the specified image and position it within the shape
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: path.bounds.width, height: path.bounds.height)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.mask = sliceLayer // Apply the shape layer as a mask to the image view
        
        // Create a tap gesture recognizer to handle image selection
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
        
        // Add the image view as a subview of the CollageView
        view.addSubview(imageView)
    }

    @objc func imageTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let imageView = gestureRecognizer.view as? UIImageView else {
            return
        }
        
        // Handle image selection here
        let selectedImage = imageView.image
        // ...
    }
}
