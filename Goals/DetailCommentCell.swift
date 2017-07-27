//
//  DetailCommentCell.swift
//  Goals
//
//  Created by Gerardo Parra on 7/27/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse

class DetailCommentCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var commentField: UITextField!
    
    var update: PFObject? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        commentField.delegate = self
        cellBackground.layer.cornerRadius = 10
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Dismiss the keyboard
        
        var commentDict: [String: Any] = [:]
        commentDict["text"] = commentField.text!
        commentDict["author"] = PFUser.current()
        
        var commentsArray = update?["comments"] as! [[String: Any]]
        commentsArray.append(commentDict)
        update?["comments"] = commentsArray
        
        commentField.text = ""
        update?.saveInBackground()
        
        return true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
