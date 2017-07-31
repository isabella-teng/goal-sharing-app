//
//  VideoViewController.swift
//  Goals
//
//  Created by Isabella Teng on 7/18/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Parse

class VideoViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var currentUpdate: PFObject?
    var videoURL: URL
    var player: AVPlayer?
    var playerController : AVPlayerViewController?
    
    init(videoURL: URL, update: PFObject) {
        self.videoURL = videoURL
        self.currentUpdate = update
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        player = AVPlayer(url: videoURL)
        playerController = AVPlayerViewController()
        
        guard player != nil && playerController != nil else {
            return
        }
        playerController!.showsPlaybackControls = false
        
        playerController!.player = player!
        self.addChildViewController(playerController!)
        self.view.addSubview(playerController!.view)
        playerController!.view.frame = view.frame
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player!.currentItem)
        
        
        let origImage = #imageLiteral(resourceName: "cross-filled")
        let tintedImage = origImage.withRenderingMode(.alwaysTemplate)
        let cancelButton = UIButton(frame: CGRect(x: 10.0, y: 20.0, width: 45.0, height: 45.0))
        cancelButton.imageView?.contentMode = UIViewContentMode.scaleAspectFill
        cancelButton.setImage(tintedImage, for: UIControlState())
        cancelButton.tintColor = UIColor.white
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        let editButton = UIButton(frame: CGRect(x: 0, y: view.frame.height - 65, width: view.frame.width, height: 65))
        editButton.setTitle("Add a caption", for: UIControlState())
        editButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 22)
        editButton.backgroundColor = UIColor(red: 0.60, green: 0.40, blue: 0.70, alpha: 1.0)
        editButton.addTarget(self, action: #selector(edit), for: .touchUpInside)
        view.addSubview(editButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
    }
    
    
    func edit() {
        let newVC: UIViewController = AddCaptionViewController(mediaInfo: videoURL, update: currentUpdate!, mediaType: "video")
        self.present(newVC, animated: true, completion: nil)
    }
    
    func cancel() {
        dismiss(animated: false, completion: nil)
    }
    
    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
        if self.player != nil {
            self.player!.seek(to: kCMTimeZero)
            self.player!.play()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddCaptionViewController
        vc.media = "video"
        vc.savedMedia = videoURL
        vc.currentUpdate = currentUpdate!
    }
}
