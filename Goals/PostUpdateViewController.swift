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


class PostUpdateViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var goalTextView: UITextView!
    @IBOutlet weak var postButton: UIButton!
    
    var currentUpdate: PFObject?
    var currentGoal: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postButton.layer.cornerRadius = postButton.frame.height / 2
        
        // Set up textview: placeholder text, etc.
        goalTextView.delegate = self
        goalTextView.text = "What's your update?"
        goalTextView.textColor = UIColor.lightGray
        goalTextView.becomeFirstResponder()
        
        //print(currentGoal?["objectId"])

    }

    @IBAction func didTapCancel(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true)
    }
    
    @IBAction func didPostUpdate(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
        // Data to post to Parse
        var data: [String: Any] = [:]
        data["text"] = goalTextView.text
        data["goalId"] = currentGoal!.objectId
        data["goalTitle"] = currentGoal!["title"]
        print(data["goalTitle"] as Any)
        
        Update.createUpdate(data: data)
        
    }
    
    
    
    // TextView placeholder text, disabled button functionality
    var firstChange = true
    func textViewDidBeginEditing(_ textView: UITextView) {
        let newPosition = goalTextView.beginningOfDocument
        goalTextView.selectedTextRange = goalTextView.textRange(from: newPosition, to: newPosition)
        if firstChange {
            postButton.isEnabled = false
            postButton.alpha = 0.7
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if goalTextView.text.isEmpty {
            goalTextView.text = "What's your update?"
            goalTextView.textColor = UIColor.lightGray
            postButton.isEnabled = false
            postButton.alpha = 0.7
            firstChange = true
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if firstChange {
            goalTextView.text = String(goalTextView.text.characters.prefix(1))
            firstChange = false
        }
        if goalTextView.text.isEmpty {
            goalTextView.text = "What's your update?"
            goalTextView.textColor = UIColor.lightGray
            
            let newPosition = goalTextView.beginningOfDocument
            goalTextView.selectedTextRange = goalTextView.textRange(from: newPosition, to: newPosition)
            firstChange = true
            
            postButton.isEnabled = false
            postButton.alpha = 0.7
        } else {
            postButton.isEnabled = true
            postButton.alpha = 1.0
            goalTextView.textColor = UIColor.black
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
