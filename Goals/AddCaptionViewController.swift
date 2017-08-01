//
//  AddCaptionViewController.swift
//  
//
//  Created by Isabella Teng on 7/18/17.
//
//

import UIKit
import SwiftyCam
import RSKPlaceholderTextView
import AVKit
import AVFoundation
import Parse

class AddCaptionViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var captionTextView: RSKPlaceholderTextView? = nil
    
    var currentUser = PFUser.current()
    var currentUpdate: PFObject?
    
    var savedMedia: Any
    var media: String
    
    init(mediaInfo: Any, update: PFObject, mediaType: String) {
        self.savedMedia = mediaInfo
        self.currentUpdate = update
        self.media = mediaType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Media view
        let mediaView = UIImageView(frame: CGRect(x: 15, y: 60, width: 100, height: 160))
        mediaView.backgroundColor = UIColor.black
        mediaView.contentMode = UIViewContentMode.scaleAspectFill
        mediaView.clipsToBounds = true
        mediaView.layer.cornerRadius = 10
        if media == "photo" {
            mediaView.image = savedMedia as? UIImage
        }
        self.view.addSubview(mediaView)
        
        // Placeholder TextView
        self.captionTextView = RSKPlaceholderTextView(frame: CGRect(x: 130, y: 60, width: self.view.frame.width - 145, height: 160))
        self.captionTextView?.placeholder = "What's your message?"
        self.captionTextView?.font = UIFont (name: "HelveticaNeue-Light", size: 22)
        self.captionTextView?.becomeFirstResponder()
        self.view.addSubview(self.captionTextView!)
        
        let border = UIView(frame: CGRect(x: 15, y: 250, width: view.frame.width - 30, height: 1))
        border.backgroundColor = UIColor.lightGray
        self.view.addSubview(border)
        
        // Cancel button
        let cancelButton = UIButton(frame: CGRect(x: 15, y: 280, width: view.frame.width / 2 - 22.5, height: 55.0))
        cancelButton.layer.cornerRadius = 5
        cancelButton.setTitle("Cancel", for: UIControlState())
        cancelButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 22)
        cancelButton.backgroundColor = UIColor(red: 0.95, green: 0.35, blue: 0.40, alpha: 1.0)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        self.view.addSubview(cancelButton)
        
        // Post button
        let postButton = UIButton(frame: CGRect(x: view.frame.width / 2 + 7.5, y: 280, width: view.frame.width / 2 - 22.5, height: 55.0))
        postButton.layer.cornerRadius = 5
        postButton.setTitle("Send", for: UIControlState())
        postButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 22)
        postButton.backgroundColor = UIColor(red: 0.60, green: 0.40, blue: 0.70, alpha: 1.0)
        postButton.addTarget(self, action: #selector(post), for: .touchUpInside)
        self.view.addSubview(postButton)
        
        self.view.backgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancel () {
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    //TODO: clean up this code, add into the object classes functions
    func post() {
        //send the media to the database
        
        //alert that message has been sent
        if (captionTextView?.text.isEmpty)! {
            let alertController = UIAlertController(title: "Empty field", message: "Cannot post an empty message", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Try again", style: .default, handler: nil )
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        } else {
            if (media == "video") {
                //Save video in updates video array
                currentUpdate?.saveInBackground(block: { (success: Bool, error: Error?) in
                    if error == nil {
                        var videoArray = self.currentUpdate?["videos"] as! [[String: Any]]
                        var videoDictionary: [String: Any] = [:]
                        videoDictionary["sender"] = self.currentUser
                        videoDictionary["caption"] = self.captionTextView?.text
                        let vid = NSData(contentsOf: self.savedMedia as! URL)
                        videoDictionary["videoURL"] = PFFile(name: "video.mov", data: vid! as Data)
                        videoArray.append(videoDictionary)
                        self.currentUpdate?["videos"] = videoArray
                        
                        //Save video in interactions array
                        var interactionsArray = self.currentUpdate?["activity"] as! [[String: Any]]
                        var newInteraction: [String: Any] = videoDictionary
                        newInteraction["type"] = "video"
                        newInteraction["createdAt"] = NSDate()
                        interactionsArray.append(newInteraction)
                        self.currentUpdate?["activity"] = interactionsArray
                        
                        self.currentUpdate?.saveInBackground()
                        
                    }
                })
                
            } else if (media == "photo") {
                //Save photo in updates photo array
                currentUpdate?.saveInBackground(block: { (success: Bool, error: Error?) in
                    if error == nil {
                        var photoArray = self.currentUpdate?["pictures"] as! [[String: Any]]
                        var photoDictionary: [String: Any] = [:]
                        photoDictionary["sender"] = self.currentUser
                        photoDictionary["caption"] = self.captionTextView?.text
                        photoDictionary["image"] = Update.getPFFileFromImage(image: self.savedMedia as? UIImage)

                        photoArray.append(photoDictionary)
                        self.currentUpdate?["pictures"] = photoArray
                        
                        //Save photo in updates interactions array
                        var interactionsArray = self.currentUpdate?["activity"] as! [[String: Any]]
                        var newInteraction: [String: Any] = photoDictionary
                        newInteraction["type"] = "photo"
                        newInteraction["text"] = self.captionTextView?.text

                        newInteraction["createdAt"] = NSDate()
                        interactionsArray.append(newInteraction)
                        self.currentUpdate?["activity"] = interactionsArray
                        
                        self.currentUpdate?.saveInBackground()
                    }
                })

            }
            
            
            
            let alertController = UIAlertController(title: "Message Sent!", message: "Thank you for sending an encouraging message!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Yay!", style: .default, handler: { (action) in
                self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
}
