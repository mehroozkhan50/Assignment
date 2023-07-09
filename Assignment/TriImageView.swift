//
//  TriImageView.swift
//  Assignment
//
//  Created by Mehrooz khan on 7/8/23.
//

import Foundation
import UIKit

protocol TriImageViewDelegate: NSObject {
    func didTapImagethree(image: UIImage, index : Int)
}

class TriImageView:UIView {

    //assumption: view width = 2 x view height

    var images = [UIImage]()

    var delegate:TriImageViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.updateView()
//        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TriImageView.handleTap(_:))))

    }
    func updateView(){
        //add imageviews
        for i in 1...3 {
            let imageView = UIImageView()
            imageView.tag = i
            imageView.isUserInteractionEnabled = true
            self.addSubview(imageView)
        }

        //add gesture recognizer
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
        self.setNeedsDisplay()
    }

    //override drawRect
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let width = rect.size.width
        let height = rect.size.height
        let frame = CGRect(x: 0, y: 0, width: width, height: height)

        let pointA = CGPoint(x: 0, y: 0)
        let pointB = CGPoint(x: width, y: 0)
        let pointC = CGPoint(x: width, y: height / 3)
        let pointD = CGPoint(x: width / 3 , y: height / 3)
        let pointE = CGPoint(x: width * 0.67, y: height / 3)
        let pointF = CGPoint(x: width * 0.67, y: height / 3)
        let pointG = CGPoint(x: width * 0.33, y: height)
        let pointH = CGPoint(x: 0, y: height)
        let pointI = CGPoint(x: 0, y: height)
        let pointJ = CGPoint(x: 0, y: height)
        let pointK = CGPoint(x: 0, y: height)
        let pointL = CGPoint(x: 0, y: height / 3)
        let pointM = CGPoint(x: 0, y: height / 3)
        let pointalpha  = CGPoint(x: width * 0.67, y: height / 3)
        let pointbeta  = CGPoint(x: width, y: height / 3)
        let pointgamma  = CGPoint(x: width * 0.33, y: height)
        let pointgamma2  = CGPoint(x: width, y: height)

        let path1 = [pointA, pointB, pointC, pointD, pointE, pointF, pointM]
        let path2 = [pointC, pointD, pointE, pointF, pointG, pointH, pointI, pointJ, pointK, pointL]
        let path3 = [pointalpha, pointbeta, pointgamma2, pointgamma]

        let paths = [path1, path2, path3]

        for i in 1...3 {
            let imageView = (self.viewWithTag(i) as! UIImageView)
            imageView.image = images[i - 1]
            imageView.frame = frame
            addMask(view: imageView, points: paths[i - 1])
        }

    }

    //Add mask to the imageview
    func addMask(view:UIView, points:[CGPoint]){

        let maskPath = UIBezierPath()
        maskPath.move(to: points[0])

        for i in 1..<points.count {
            maskPath.addLine(to: points[i])
        }

        maskPath.close()

        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer

    }

    //handle tap
    @objc func handleTap(recognizer:UITapGestureRecognizer){

        let point = recognizer.location(in: recognizer.view)

        for i in 1...3 {
            let imageView = (self.viewWithTag(i) as! UIImageView)
            let layer = (imageView.layer.mask as! CAShapeLayer)
            let path = layer.path
            
            let contains = path?.contains(point)
            
            if contains == true {
                delegate?.didTapImagethree(image: imageView.image!, index: i)
            }

        }



    }

}
