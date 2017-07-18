//
//  PostCommentViewController.swift
//  Goals
//
//  Created by Gerardo Parra on 7/13/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import RSKPlaceholderTextView
import Parse
import ParseUI


class PostCommentViewController: UIViewController {

    var commentTextView: RSKPlaceholderTextView? = nil
    
//    var update: PFObject! {
//        didSet{
//            self.commentTextView.text = update["comments"] as? String
//            let currentCommentCount = update["commentCount"] as! Int
//        }
//    }
    
    var currentUpdate: PFObject?
    
    
    @IBOutlet weak var commentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Placeholder TextView
        self.commentTextView = RSKPlaceholderTextView(frame: CGRect(x: 16, y: 69, width: self.view.frame.width - 32, height: 122))
        self.commentTextView?.placeholder = "Comment on this update"
        self.view.addSubview(self.commentTextView!)
        self.commentTextView?.becomeFirstResponder()
        self.commentTextView?.font = UIFont (name: "HelveticaNeue-Light", size: 22)
        
        commentButton.layer.cornerRadius = commentButton.frame.height / 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }

    @IBAction func didTapComment(_ sender: Any) {
        if (commentTextView?.text.isEmpty)! {
            let alertController = UIAlertController(title: "Empty field", message: "Cannot post an empty comment", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Try again", style: .default, handler: nil )
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        } else {
            // Post comment to database
            self.dismiss(animated: true)
            
            currentUpdate?.saveInBackground(block: { (success: Bool, error: Error?) in
                if error == nil {
                    //print("made it")
                    var commentsArray = self.currentUpdate?["comments"] as! [[String: Any]]
                    var commentsDictionary: [String: Any] = [:]
                    commentsDictionary["commentUser"] = PFUser.current()
                    commentsDictionary["commentText"] = self.commentTextView?.text
                    
                    commentsArray.append(commentsDictionary)
                    self.currentUpdate?["comments"] = commentsArray
                    self.currentUpdate?.incrementKey("likeCount", byAmount: 1)
                    self.currentUpdate?.saveInBackground()
                } else {
                    print(error?.localizedDescription)
                }
            })
            
            
            
        }
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
