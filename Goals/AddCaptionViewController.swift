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
import Parse

class AddCaptionViewController: UIViewController {

    //@IBOutlet weak var postButton: UIButton!
    
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
        
        // Placeholder TextView
        self.captionTextView = RSKPlaceholderTextView(frame: CGRect(x: 16, y: 69, width: self.view.frame.width - 32, height: 122))
        self.captionTextView?.placeholder = "What's your message?"
        self.view.addSubview(self.captionTextView!)
        self.captionTextView?.becomeFirstResponder()
        self.captionTextView?.font = UIFont (name: "HelveticaNeue-Light", size: 22)

        self.view.backgroundColor = UIColor.gray
        
        
//        print(currentUpdate?.objectId)
//        print(savedMedia)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let test = CGFloat((view.frame.width - (view.frame.width / 2 + 37.5)) + ((view.frame.width / 2) - 37.5) - 9.0)
        
        let postButton = UIButton(frame: CGRect(x: test, y: view.frame.height - 350, width: 30.0, height: 40.0))

        postButton.setImage(#imageLiteral(resourceName: "send"), for: UIControlState())
        postButton.addTarget(self, action: #selector(post), for: .touchUpInside)
        self.view.addSubview(postButton)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
                //updating updates video dictionary
                currentUpdate?.saveInBackground(block: { (success: Bool, error: Error?) in
                    if error == nil {
                        var videoArray = self.currentUpdate?["videos"] as! [[String: Any]]
                        var videoDictionary: [String: Any] = [:]
                        videoDictionary["author"] = self.currentUser
                        videoDictionary["caption"] = self.captionTextView?.text
                        videoDictionary["videoURL"] = "\(self.savedMedia as! URL)"
                        
                        videoArray.append(videoDictionary)
                        self.currentUpdate?["videos"] = videoArray
                        
                        self.currentUpdate?.saveInBackground()
                        
                    }
                })
            }
            
            
            
            let alertController = UIAlertController(title: "Message Sent!", message: "Thank you for sending an encouraging message!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Yay!", style: .default, handler: nil )
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: {
                self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
            })
            
            //fix to this!! only go back to feed view controller once you've clicked ok
//            alertController.addAction(UIAlertAction(title: "Yay!", style: .default, handler: { (action: UIAlertAction!) in
//                print("sent message")
//                self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
//            }))
        

            
        }
        
    }
    
    
    
    


}
