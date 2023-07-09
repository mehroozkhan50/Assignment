//
//  VideoProcessingViewController.swift
//  Assignment
//
//  Created by Mehrooz khan on 7/8/23.
//

import AVFoundation
import UIKit
import CoreImage
import Photos

class VideoProcessingViewController: UIViewController {
    var videoURL: URL?
    @IBOutlet weak var videoView : UIView!
    private var player: AVPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func processVideo() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = ["public.movie"]
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func startProcessing(sender : UIButton){
        
        self.extractImagesFromVideo()
    }
    @IBAction func selectVideo(sender : UIButton){
        processVideo()
    }

    func blurImage(_ image: UIImage) -> UIImage? {
        let blurFilter = CIFilter(name: "CIGaussianBlur")
        blurFilter?.setDefaults()
        blurFilter?.setValue(10, forKey: kCIInputRadiusKey)

        guard let ciImage = CIImage(image: image) else {
            return nil
        }
        blurFilter?.setValue(ciImage, forKey: kCIInputImageKey)

        guard let outputImage = blurFilter?.outputImage else {
            return nil
        }
        let context = CIContext()
        guard let blurredCGImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        return UIImage(cgImage: blurredCGImage)
    }

    func saveImageToCameraRoll(_ image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                print("Permission to access photo library denied.")
                return
            }

            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                request.creationDate = Date()
            }, completionHandler: { success, error in
                if success {
                    print("Image saved to camera roll.")
                } else if let error = error {
                    print("Error saving image to camera roll: \(error)")
                }
            })
        }
    }
    func loadVideo() {
        guard let videoURL = videoURL else {
            return
        }

        player = AVPlayer(url: videoURL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoView.bounds
        playerLayer.videoGravity = .resizeAspectFill
        videoView.layer.addSublayer(playerLayer)

        player?.play()
    }
}

extension VideoProcessingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let videoURL = info[.mediaURL] as? URL {
            self.videoURL = videoURL
            picker.dismiss(animated: true) {
                self.loadVideo()
            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func extractImagesFromVideo() {
        guard let videoURL = videoURL else {
            return
        }

        let asset = AVURLAsset(url: videoURL)
        let duration = CMTimeGetSeconds(asset.duration)

        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true

        var currentTime: Double = 0
        var imageCount = 0

        while currentTime < duration {
            let time = CMTime(seconds: currentTime, preferredTimescale: 600)
            do {
                let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
                let image = UIImage(cgImage: imageRef)

                if let blurredImage = blurImage(image) {
                    saveImageToCameraRoll(blurredImage)
                    imageCount += 1
                }
            } catch {
                print("Error generating image: \(error)")
            }

            currentTime += 30
            if currentTime > duration {
                // Adjust the last image capture to the end time of the video
                currentTime = duration
            }
        }

        print("Total images processed: \(imageCount)")
    }
}
