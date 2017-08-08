//
//  FullMediaViewController.swift
//  Goals
//
//  Created by Gerardo Parra on 8/1/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import AVKit
import AVFoundation

class FullMediaViewController: UIViewController, UIScrollViewDelegate, AVPlayerViewControllerDelegate, AVAudioPlayerDelegate {
   
   @IBOutlet weak var mediaView: UIImageView!
   @IBOutlet weak var captionLabel: UILabel!
   @IBOutlet weak var authorIcon: UIImageView!
   @IBOutlet weak var authorUsername: UILabel!
   @IBOutlet weak var scrollView: UIScrollView!
   @IBOutlet weak var cancelButton: UIButton!
   
   var data: [String: Any]?
   
   var fromForceTouch: Bool = false
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      scrollView.minimumZoomScale = 1.0
      scrollView.maximumZoomScale = 3.0
      scrollView.delegate = self
      
      if fromForceTouch {
         cancelButton.isHidden = true
      }
   }
   
   
   override func viewDidAppear(_ animated: Bool) {
      print("heyo")
      let author = data?["sender"] as! PFUser
      author.fetchIfNeededInBackground { (authorObject: PFObject?, error: Error?) in
         if error == nil {
            let loadedAuthor = authorObject as! PFUser
            
            let iconUrl = loadedAuthor["portrait"] as? PFFile
            iconUrl?.getDataInBackground(block: { (data: Data?, error: Error?) in
               if error == nil {
                  self.authorIcon.image = UIImage(data: data!)
               }
            })
            
            self.authorUsername.text = loadedAuthor.username!
         }
      }
      
      captionLabel.text = data?["caption"] as? String
      
      if data?["type"] as! String == "photo" {
         if let urlString = data?["image"] as? PFFile {
            urlString.getDataInBackground(block: { (imageData: Data?, error: Error?) in
               if error == nil {
                  var fullImg = UIImage(data: imageData!)
                  if (self.data?["rotated"] == nil) {
                     fullImg = self.imageRotatedByDegrees(oldImage: fullImg!, deg: 90)
                  }
                  self.mediaView.image = fullImg
               }
            })
         }
      } else if data?["type"] as! String == "video" {
         let videoFile = data?["videoURL"] as? PFFile
         let videoUrl = videoFile?.url
         let asset = AVAsset(url: URL(string: videoUrl!)!)
         let item = AVPlayerItem(asset: asset)
         let player = AVPlayer(playerItem: item)
         
         let playerController = AVPlayerViewController()
         self.addChildViewController(playerController)
         playerController.player = player
         playerController.view.frame = self.mediaView.frame
         playerController.view.clipsToBounds = true
         playerController.view.contentMode = UIViewContentMode.scaleAspectFill
         playerController.view.layer.cornerRadius = 10
         playerController.videoGravity = AVLayerVideoGravityResizeAspectFill
         playerController.delegate = self
         //self.addSubview(playerController.view)
         
         player.play()
         
         
      }
      authorIcon.layer.cornerRadius = 10
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
   
   func viewForZooming(in scrollView: UIScrollView) -> UIView? {
      return mediaView
   }
   
   @IBAction func onCancel(_ sender: Any) {
      self.dismiss(animated: true, completion: nil)
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
}
