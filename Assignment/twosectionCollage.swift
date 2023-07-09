//
//  twosectionCollage.swift
//  Assignment
//
//  Created by Mehrooz khan on 7/8/23.
//

import Foundation
import UIKit

protocol TwoImagesViewDelegate: NSObject {
    func didTapImage(image: UIImage, withindex : Int)
}

class TwoImagesCollage:UIView {

    var images = [UIImage]()

    var delegate:TwoImagesViewDelegate?
    

    override func awakeFromNib() {
        super.awakeFromNib()

        self.updateView()
    }
    func updateView(){

        for i in 1...2 {
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
            let pointB = CGPoint(x: width * 0.67, y: 0)
            let pointC = CGPoint(x: width, y: 0)
            let pointD = CGPoint(x: width, y: 0)
            let pointE = CGPoint(x: 0, y: height)
            let pointF = CGPoint(x: width, y: height)
            let pointG = CGPoint(x: width, y: height)
            let pointH = CGPoint(x: width * 0.33, y: height)

            let path1 = [pointA, pointB, pointH, pointE]
            let path2 = [pointB, pointC, pointG, pointH]
            let path3 = [pointC, pointD, pointF, pointG]

        let paths = [path1,path2]

        for i in 1...2 {
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

        for i in 1...2 {
            let imageView = (self.viewWithTag(i) as! UIImageView)
            let layer = (imageView.layer.mask as! CAShapeLayer)
            let path = layer.path
            
            let contains = path?.contains(point)
            
            if contains == true {
                delegate?.didTapImage(image: imageView.image!,withindex: i)
            }

        }



    }

}
