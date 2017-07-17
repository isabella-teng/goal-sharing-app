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
    
    var currentUpdate: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Placeholder TextView
        self.updateTextView = RSKPlaceholderTextView(frame: CGRect(x: 16, y: 69, width: self.view.frame.width - 32, height: 122))
        self.updateTextView?.placeholder = "Update your goal..."
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
        self.dismiss(animated: true, completion: nil)
        
        // Data to post to Parse
        var data: [String: Any] = [:]
        data["text"] = updateTextView?.text
        data["goalId"] = currentUpdate!["goalId"]
        
        Update.createUpdate(data: data)
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
