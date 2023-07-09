//
//  CollageViewController.swift
//  Assignment
//
//  Created by Mehrooz khan on 7/8/23.
//

import UIKit

enum collages : Int{
    case twoSections = 0
    case threeSections = 1
}


class CollageViewController: UIViewController {
    @IBOutlet var collageView : TriImageView!
    @IBOutlet var twoSectionCollage : TwoImagesCollage!
    
    @IBOutlet var button1 : UIButton!
    @IBOutlet var button2  : UIButton!
    
    var twoSelectionSelectedImageIndex = 0
    var threeSelectionSelectedImageIndex = 0
    var selected : collages = .twoSections

    override func viewDidLoad() {
        super.viewDidLoad()
        twoSectionCollage.images = [UIImage(named: "1")!,UIImage(named: "2")!]
        twoSectionCollage.delegate = self
        collageView.images = [UIImage(named: "1")!,UIImage(named: "2")!,UIImage(named: "3")!]
        self.collageView.delegate = self
        setupButtons()
        self.collageView.isHidden = true
        self.twoSectionCollage.isHidden = false
    }
    
    
    func setupButtons() {
        
        button1.addTarget(self, action: #selector(switchToCollage1), for: .touchUpInside)
        button2.addTarget(self, action: #selector(switchToCollage2), for: .touchUpInside)
    }
    
    @IBAction func saveImage(sender : UIButton){
        switch selected {
        case .twoSections:
            let renderer = UIGraphicsImageRenderer(bounds: twoSectionCollage.bounds)
                let image = renderer.image { context in
                    twoSectionCollage.layer.render(in: context.cgContext)
                }
                
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
        case .threeSections:
            let renderer = UIGraphicsImageRenderer(bounds: collageView.bounds)
                let image = renderer.image { context in
                    collageView.layer.render(in: context.cgContext)
                }
                
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        
    }
    @objc func imageSaved(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // Failed to save the image
            print("Error saving image: \(error.localizedDescription)")
            self.showAlert(title: "Error", message: "Error saving image: \(error.localizedDescription)")
        } else {
            // Image saved successfully
            print("Image saved to gallery")
            self.showAlert(title: "Success", message: "Image saved to gallery")
        }
    }
    
    @objc func switchToCollage1() {
        self.collageView.isHidden = true
        self.twoSectionCollage.isHidden = false
        self.selected = .twoSections
        // Switch to collage type 1
        //collageView.currentCollageType = .collage1
    }
    
    @objc func switchToCollage2() {
        self.collageView.isHidden = false
        self.twoSectionCollage.isHidden = true
        self.selected = .threeSections
        // Switch to collage type 2
        //collageView.currentCollageType = .collage2
    }
}
extension CollageViewController : TwoImagesViewDelegate, UINavigationControllerDelegate{
    func didTapImage(image: UIImage, withindex withIndex: Int) {
        twoSelectionSelectedImageIndex = withIndex
        let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
    }
    
    
}
extension CollageViewController : TriImageViewDelegate{
    func didTapImagethree(image: UIImage, index: Int) {
        threeSelectionSelectedImageIndex = index
        let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
    }
}
extension CollageViewController : UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        switch selected{
            
        case .twoSections:
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                // Replace the image at a specific index with the picked image
                let indexToReplace = twoSelectionSelectedImageIndex - 1 // Change this to the desired index
                if indexToReplace >= 0 && indexToReplace < twoSectionCollage.images.count {
                    twoSectionCollage.images[indexToReplace] = pickedImage
                    twoSectionCollage.updateView()
                }
                
                
            }
        case .threeSections:
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                // Replace the image at a specific index with the picked image
                let indexToReplace = threeSelectionSelectedImageIndex - 1 // Change this to the desired index
                if indexToReplace >= 0 && indexToReplace < collageView.images.count {
                    collageView.images[indexToReplace] = pickedImage
                    collageView.updateView()
                }
            }
        }
        
    }
}
