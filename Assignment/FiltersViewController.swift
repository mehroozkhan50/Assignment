//
//  FiltersViewController.swift
//  Assignment
//
//  Created by Mehrooz khan on 7/8/23.
//

import UIKit
import GPUImage

enum filters : Int{
    case Char = 0
    case Amaro
    case Dawn
    case Gold
    case Willow
}

class FiltersViewController: UIViewController {
    @IBOutlet weak var sourceImageView: UIImageView!
    @IBOutlet weak var filteredImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var sourceImage : UIImage! = nil
    let filtersArray : [filters] = [.Char,.Amaro,.Dawn,.Gold,.Willow]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if sourceImage == nil{
            
        }else{
            
        }
    }
    
    @IBAction func pickImageTapped(sender : UIButton){
        self.showImagePicker()
    }
    @IBAction func saveImageTapped(sender : UIButton){
        if sourceImage != nil{
            UIImageWriteToSavedPhotosAlbum(sourceImageView.image!, self, #selector(imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
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

}
extension FiltersViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if sourceImage == nil{
            return 0
        }
        return filtersArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : FilterViewCell = (collectionView.dequeueReusableCell(withReuseIdentifier: "FilterViewCell", for: indexPath) as? FilterViewCell)!
        cell.sourceImg = self.sourceImage
        cell.filter = self.filtersArray[indexPath.item]
        cell.setupUI()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filter = self.filtersArray[indexPath.item]
        switch filter{
        case .Amaro:
            let blurFilter = GPUImageGrayscaleFilter()
            
            let outputImage = blurFilter.image(byFilteringImage: sourceImage)
            sourceImageView.image = outputImage
        
        case .Char:
            let blurFilter = GPUImageSwirlFilter()
            
            let outputImage = blurFilter.image(byFilteringImage: sourceImage)
            sourceImageView.image = outputImage
        case .Dawn:
            let blurFilter = GPUImageThresholdSketchFilter()
            
            let outputImage = blurFilter.image(byFilteringImage: sourceImage)
            sourceImageView.image = outputImage
        case .Gold:
            let blurFilter = GPUImageBrightnessFilter()
            
            let outputImage = blurFilter.image(byFilteringImage: sourceImage)
            sourceImageView.image = outputImage
        case .Willow:
            let blurFilter = GPUImageRGBFilter()
            blurFilter.blue = 0.7
            blurFilter.green = 0.4
            blurFilter.red = 0.6
            let outputImage = blurFilter.image(byFilteringImage: sourceImage)
            sourceImageView.image = outputImage
        }
    }
}
extension FiltersViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            sourceImage = pickedImage
            sourceImageView.image = pickedImage
            
            self.collectionView.reloadData()
            //applyFilter(to: pickedImage)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
