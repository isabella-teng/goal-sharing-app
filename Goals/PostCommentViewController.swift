//
//  PostCommentViewController.swift
//  Goals
//
//  Created by Gerardo Parra on 7/13/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import RSKPlaceholderTextView

class PostCommentViewController: UIViewController {

    var commentTextView: RSKPlaceholderTextView? = nil
    
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

    @IBAction func didTapCancel(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true)
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
