//
//  DetailCommentCell.swift
//  Goals
//
//  Created by Gerardo Parra on 7/27/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse

//protocol didPostCommentDelegate: class {
//    func didComment(comment: PFObject)
//}

class DetailCommentCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var commentField: UITextField!
    
    var update: PFObject? = nil
    var parent: UITableView? = nil
    var vc: DetailViewController? = nil
    var animationDistance: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        commentField.delegate = self
        cellBackground.layer.cornerRadius = 10
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Dismiss the keyboard
        UITableView.animate(withDuration: 0.3) {
            var frame = self.parent?.frame
            frame?.origin.y += CGFloat(self.animationDistance)
            self.parent?.frame = frame!
        }
        
        var commentDict: [String: Any] = [:]
        commentDict["text"] = commentField.text!
        commentDict["author"] = PFUser.current()
        
        var commentsArray = update?["comments"] as! [[String: Any]]
        commentsArray.append(commentDict)
        update?["comments"] = commentsArray
        update?.incrementKey("commentCount", byAmount: 1)
        
        self.vc?.comments.append(["author": PFUser.current()!, "text": self.commentField.text!])
        self.parent?.reloadData()
        let indexPath = IndexPath(row:  (vc?.comments.count)!, section: 0)
        self.parent?.scrollToRow(at: indexPath, at: .bottom, animated: true)
        
        commentField.text = ""
        update?.saveInBackground()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UITableView.animate(withDuration: 0.3) {
            var frame = self.parent?.frame
            self.animationDistance = min(Int(self.frame.origin.y) , Int((self.parent?.frame.height)! - (self.frame.height)))
            frame?.origin.y -= CGFloat(self.animationDistance)
            self.parent?.frame = frame!
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
