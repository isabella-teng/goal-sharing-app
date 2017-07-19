//
//  PostUpdateViewController.swift
//  Goals
//
//  Created by Gerardo Parra on 7/12/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import RSKPlaceholderTextView

class PostUpdateViewController: UIViewController, UITextViewDelegate {

    var updateTextView: RSKPlaceholderTextView? = nil
    @IBOutlet weak var postButton: UIButton!
    
    @IBOutlet weak var typeControl: UISegmentedControl!
    
    var currentGoal: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Placeholder TextView
        self.updateTextView = RSKPlaceholderTextView(frame: CGRect(x: 16, y: 69, width: self.view.frame.width - 32, height: 122))
        self.updateTextView?.placeholder = "What's your update?"
        self.view.addSubview(self.updateTextView!)
        self.updateTextView?.becomeFirstResponder()
        self.updateTextView?.font = UIFont (name: "HelveticaNeue-Light", size: 22)

        postButton.layer.cornerRadius = postButton.frame.height / 2
    
    }

    @IBAction func didTapCancel(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true)
    }
    
    @IBAction func didPostUpdate(_ sender: Any) {
        if (updateTextView?.text.isEmpty)! {
            let alertController = UIAlertController(title: "Empty field", message: "Cannot post an empty update", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Try again", style: .default, handler: nil )
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
            
            // Data to post to Parse
            var data: [String: Any] = [:]
            data["text"] = updateTextView?.text
            data["goalId"] = currentGoal?.objectId
            data["goalTitle"] = currentGoal!["title"]
            
            let updateType = Update.returnUpdateType(index: typeControl.selectedSegmentIndex)
            data["type"] = updateType
            
            Update.createUpdate(data: data)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
