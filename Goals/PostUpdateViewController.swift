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
    
    var textHasBeenEdited = false
    
    var currentUpdate: PFObject?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postButton.layer.cornerRadius = postButton.frame.height / 2
        
        goalTextView.delegate = self
        goalTextView.text = "What's your update?"
        goalTextView.textColor = UIColor.lightGray
        goalTextView.becomeFirstResponder()
        
        print(currentUpdate!["goalId"])
        
        
    }

    @IBAction func didTapCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didPostUpdate(_ sender: Any) {
        print("hello")
        self.dismiss(animated: true, completion: nil)
        var data: [String: Any] = [:]
        data["text"] = goalTextView.text
        data["goalId"] = currentUpdate!["goalId"]
        
        Update.createUpdate(data: data)
    }
    
    // Placeholder, disabled button functionality
    func textViewDidBeginEditing(_ textView: UITextView) {
        let newPosition = goalTextView.beginningOfDocument
        goalTextView.selectedTextRange = goalTextView.textRange(from: newPosition, to: newPosition)
        if !textHasBeenEdited {
            postButton.isEnabled = false
            postButton.alpha = 0.7
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if goalTextView.text.isEmpty {
            textHasBeenEdited = false
            goalTextView.text = "What's your update?"
            goalTextView.textColor = UIColor.lightGray
            postButton.isEnabled = false
            postButton.alpha = 0.7
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if !textHasBeenEdited {
            goalTextView.text = String(goalTextView.text.characters.prefix(1))
            goalTextView.textColor = UIColor.black
            textHasBeenEdited = true
            postButton.isEnabled = true
            postButton.alpha = 1.0
        } else if goalTextView.text == "" {
            postButton.isEnabled = false
            postButton.alpha = 0.7
        } else {
            postButton.isEnabled = true
            postButton.alpha = 1.0
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
