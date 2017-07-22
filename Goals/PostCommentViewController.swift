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
    var currentUpdate: PFObject?
    var currentGoal: PFObject?
    
//    var update: PFObject! {
//        didSet{
//            self.commentTextView.text = update["comments"] as? String
//            let currentCommentCount = update["commentCount"] as! Int
//        }
//    }
    
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
        
        commentButton.isEnabled = false
        commentButton.alpha = 0.7
        
        // Fetch current goal
        Goal.fetchGoalWithId(id: currentUpdate?["goalId"] as! String) { (goal: PFObject?, error: Error?) in
            if error == nil {
                self.currentGoal = goal
                self.commentButton.isEnabled = true
                self.commentButton.alpha = 1.0
            }
        }
    }

    @IBAction func didTapComment(_ sender: Any) {
        if (commentTextView?.text.isEmpty)! {
            let alertController = UIAlertController(title: "Empty field", message: "Cannot post an empty comment", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Try again", style: .default, handler: nil )
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        } else {
            self.dismiss(animated: true)
            
            // Save comment in current update object
            currentUpdate?.saveInBackground(block: { (success: Bool, error: Error?) in
                if error == nil {
                    var commentsArray = self.currentUpdate?["comments"] as! [[String: Any]]
                    var commentsDictionary: [String: Any] = [:]
                    commentsDictionary["sender"] = PFUser.current()
                    commentsDictionary["text"] = self.commentTextView?.text
                    commentsArray.append(commentsDictionary)
                    self.currentUpdate?["comments"] = commentsArray
                    self.currentUpdate?.incrementKey("commentCount", byAmount: 1)
                    
                    //Save updates activity array
                    var interactionsArray = self.currentUpdate?["activity"] as! [[String: Any]]
                    var newInteraction: [String: Any] = commentsDictionary
                    newInteraction["type"] = "comment"
                    newInteraction["createdAt"] = NSDate()
                    interactionsArray.append(newInteraction)
                    self.currentUpdate?["activity"] = interactionsArray
                    
                    self.currentUpdate?.saveInBackground()
                } else {
                    print(error?.localizedDescription as Any)
                }
            })
            
            // Save comment in goal interactions array
//             currentGoal?.saveInBackground(block: { (success: Bool, error: Error?) in
//                 if error == nil {
//                     var interactionsArray = self.currentGoal?["activity"] as! [[String: Any]]
//                     var newInteraction: [String: Any] = [:]
//                     newInteraction["sender"] = PFUser.current()
//                     newInteraction["type"] = "comment"
//                     newInteraction["text"] = self.commentTextView?.text
//                     newInteraction["createdAt"] = NSDate()
//                     
//                     interactionsArray.append(newInteraction)
//                     self.currentGoal?["activity"] = interactionsArray
//                     self.currentGoal?.saveInBackground()
//                 } else {
//                     print(error?.localizedDescription as Any)
//                 }
//             })
            
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
