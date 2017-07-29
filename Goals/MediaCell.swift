//
//  MediaCell.swift
//  Goals
//
//  Created by Gerardo Parra on 7/20/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse
import AVKit
import AVFoundation


class MediaCell: UICollectionViewCell, AVPlayerViewControllerDelegate {
    
    @IBOutlet weak var mediaImage: UIImageView!
    
    var onDetails: Bool? = nil {
        didSet {
            if onDetails != nil {
                mediaImage.layer.cornerRadius = 10
            }
        }
    }
    
    var data: [String: Any] = [:] {
        didSet {
            if data["type"] as! String == "photo" {
                if let urlString = data["image"] as? PFFile {
                    urlString.getDataInBackground { (imageData: Data?, error: Error?) in
                        if error == nil {
                            var profImage = UIImage(data: imageData!)
                            profImage = self.imageRotatedByDegrees(oldImage: profImage!, deg: 90)
                            self.mediaImage.image = profImage
                        }
                    }
                }
                
            } else if data["type"] as! String == "video" {                
                let videoFile = data["videoURL"] as? PFFile
                let videoUrl = videoFile?.url
                let asset = AVAsset(url: URL(string: videoUrl!)!)
                let item = AVPlayerItem(asset: asset)
                let player = AVPlayer(playerItem: item)
                let playerController = AVPlayerViewController()
                playerController.player = player
                playerController.view.frame = self.mediaImage.frame
                playerController.view.clipsToBounds = true
                playerController.view.layer.cornerRadius = 10
                self.addSubview(playerController.view)
            }
        }
    }
    
    func imageRotatedByDegrees(oldImage: UIImage, deg degrees: CGFloat) -> UIImage {
        //Calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: oldImage.size.width, height: oldImage.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        //Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(oldImage.cgImage!, in: CGRect(x: -oldImage.size.width / 2, y: -oldImage.size.height / 2, width: oldImage.size.width, height: oldImage.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
