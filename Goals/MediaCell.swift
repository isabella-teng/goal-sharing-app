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
    
    //let player = AVPlayer()
    
    var data: [String: Any] = [:] {
        didSet {
            if data["type"] as! String == "photo" {
                print("is a picture")
                if let urlString = data["image"] as? PFFile {
                    urlString.getDataInBackground { (imageData: Data?, error: Error?) in
                        if error == nil {
                            let profImage = UIImage(data: imageData!)
                            self.mediaImage.image = profImage
                        }
                    }
                }
                
            } else if data["type"] as! String == "video" {
                print("is a video")
                mediaImage.backgroundColor = UIColor(red: 0.85, green: 0.30, blue: 0.30, alpha: 1.0)
                
                let videoFile = data["videoURL"] as? PFFile
                let videoUrl = videoFile?.url
                let asset = AVAsset(url: URL(string: videoUrl!)!)
                let item = AVPlayerItem(asset: asset)
                let player = AVPlayer(playerItem: item)
                let playerController = AVPlayerViewController()
                playerController.player = player
                playerController.view.frame = self.mediaImage.frame
                self.mediaImage.addSubview(playerController.view)
                player.play()
//                videoString?.getDataInBackground(block: { (videoData: Data?, error: Error?) in
//                    if error == nil {
//                        let asset = AVAsset(url: <#T##URL#>)
//                        let item = AVPlayerItem(asset: asset)
//                        let player = AVPlayer(playerItem: item)
//                        let playerController = AVPlayerViewController()
//                        playerController.player = player
//                        playerController.view.frame = self.mediaImage.frame
//                        self.mediaImage.addSubview(playerController.view)
//                        player.play()
//                    }
//                })

                
//                let asset = AVAsset(url: videoURL)
//                let item = AVPlayerItem(asset: asset)
//                let player = AVPlayer(playerItem: item)
//                //let player = AVPlayer(url: videoURL)
//                let playerController = AVPlayerViewController()
//                playerController.player = player
//                playerController.view.frame = mediaImage.frame
//                self.mediaImage.addSubview(playerController.view)
//                player.play()
//                print("should be playing")
                
//                let player = AVPlayer(url: videoURL!)
//                let playerLayer = AVPlayerLayer(player: player)
//                playerLayer.frame = mediaImage.bounds
//                self.mediaImage.layer.addSublayer(playerLayer)
//                player.play()
            }
        }
    }
    
    @IBOutlet weak var mediaImage: UIImageView!
}
