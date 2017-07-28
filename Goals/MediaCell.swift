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
    
    var data: [String: Any] = [:] {
        didSet {
            if data["type"] as! String == "photo" {
                if let urlString = data["image"] as? PFFile {
                    urlString.getDataInBackground { (imageData: Data?, error: Error?) in
                        if error == nil {
                            let profImage = UIImage(data: imageData!)
                            self.mediaImage.image = profImage
                        }
                    }
                }
                
            } else if data["type"] as! String == "video" {
                mediaImage.backgroundColor = UIColor(red: 0.85, green: 0.30, blue: 0.30, alpha: 1.0)
                
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
}
