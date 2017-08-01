//
//  CameraViewController.swift
//  Goals
//
//  Created by Isabella Teng on 7/18/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import SwiftyCam
import Parse
import ParseUI

class CameraViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate {
    
    var currentUpdate: PFObject?

    var captureButton: SwiftyCamRecordButton!
    var flipCameraButton: UIButton!
    var flashButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraDelegate = self
        //defaultCamera = .front
        maximumVideoDuration = 10.0
        shouldUseDeviceOrientation = true
        allowAutoRotate = true
        audioEnabled = true
        addButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        // Called when takePhoto() is called or if a SwiftyCamButton initiates a tap gesture
        // Returns a UIImage captured from the current session
        
        let vc = PhotoViewController(image: photo, update: self.currentUpdate!)
        self.present(vc, animated: false, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        // Called when startVideoRecording() is called
        // Called if a SwiftyCamButton begins a long press gesture
        captureButton.growButton()
        UIView.animate(withDuration: 0.25, animations: {
            self.flashButton.alpha = 0.0
            self.flipCameraButton.alpha = 0.0
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        // Called when stopVideoRecording() is called
        // Called if a SwiftyCamButton ends a long press gesture
        captureButton.shrinkButton()
        UIView.animate(withDuration: 0.25, animations: {
            self.flashButton.alpha = 1.0
            self.flipCameraButton.alpha = 1.0
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) { //send over the video url and the current update
        // Called when stopVideoRecording() is called and the video is finished processing
        // Returns a URL in the temporary directory where video is stored
        
        let newVC = VideoViewController(videoURL: url, update: self.currentUpdate!)
        self.present(newVC, animated: false, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        // Called when a user initiates a tap gesture on the preview layer
        // Will only be called if tapToFocus = true
        // Returns a CGPoint of the tap location on the preview layer
        let focusView = UIImageView(image: #imageLiteral(resourceName: "focus"))
        focusView.center = point
        focusView.alpha = 0.0
        view.addSubview(focusView)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            focusView.alpha = 1.0
            focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }, completion: { (success) in
            UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
                focusView.alpha = 0.0
                focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
            }, completion: { (success) in
                focusView.removeFromSuperview()
            })
        })

    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        // Called when a user initiates a pinch gesture on the preview layer
        // Will only be called if pinchToZoomn = true
        // Returns a CGFloat of the current zoom level
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        // Called when user switches between cameras
        // Returns current camera selection
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
   func cameraSwitchAction(_ sender: Any) {
        switchCamera()
    }
    
    func toggleFlashAction(_ sender: Any) {
        flashEnabled = !flashEnabled
        
        if flashEnabled == true {
            flashButton.setImage(#imageLiteral(resourceName: "flash"), for: UIControlState())
        } else {
            flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControlState())
        }
    }
    

    func addButtons() {
        captureButton = SwiftyCamRecordButton(frame: CGRect(x: view.frame.midX - 37.5, y: view.frame.height - 100.0, width: 75.0, height: 75.0))
        self.view.addSubview(captureButton)
        captureButton.delegate = self
        
        flipCameraButton = UIButton(frame: CGRect(x: (((view.frame.width / 2 - 37.5) / 2) - 15.0), y: view.frame.height - 74.0, width: 30.0, height: 23.0))
        flipCameraButton.setImage(#imageLiteral(resourceName: "flipCamera"), for: UIControlState())
        flipCameraButton.addTarget(self, action: #selector(cameraSwitchAction(_:)), for: .touchUpInside)
        self.view.addSubview(flipCameraButton)
        
        let test = CGFloat((view.frame.width - (view.frame.width / 2 + 37.5)) + ((view.frame.width / 2) - 37.5) - 9.0)
        
        flashButton = UIButton(frame: CGRect(x: test, y: view.frame.height - 77.5, width: 18.0, height: 30.0))
        flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControlState())
        flashButton.addTarget(self, action: #selector(toggleFlashAction(_:)), for: .touchUpInside)
        self.view.addSubview(flashButton)
        
        let cancelButton = UIButton(frame: CGRect(x: 10.0, y: 20.0, width: 40.0, height: 35.0))
        cancelButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        cancelButton.setImage(#imageLiteral(resourceName: "left-arrow"), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(cancelButton)
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
   
    //change shrinkButton function to
    //    if self.innerCircle == nil {
    //    innerCircle = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
    //    innerCircle.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
    //    innerCircle.backgroundColor = UIColor.red
    //    innerCircle.layer.cornerRadius = innerCircle.frame.size.width / 2
    //    innerCircle.clipsToBounds = true
    //    self.addSubview(innerCircle)
    //
    //    self.innerCircle.transform = CGAffineTransform(scaleX: 62.4, y: 62.4)
    //    self.circleBorder.setAffineTransform(CGAffineTransform(scaleX: 1.352, y: 1.352))
    //    self.circleBorder.borderWidth = (6 / 1.352)
    //
    //    }
    //    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
    //    self.innerCircle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    //    self.circleBorder.setAffineTransform(CGAffineTransform(scaleX: 1.0, y: 1.0))
    //    self.circleBorder.borderWidth = 6.0
    //    }, completion: { (success) in
    //    self.innerCircle.removeFromSuperview()
    //    self.innerCircle.isHidden = true;
    //    })\

}
