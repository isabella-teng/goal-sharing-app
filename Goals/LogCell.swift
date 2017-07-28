//
//  LogCell.swift
//  Goals
//
//  Created by Isabella Teng on 7/12/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import Foundation

import UIKit
import Parse

class LogCell: UITableViewCell {
    
    @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var commenterIcon: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    
    var update: [String: Any] = [:] {
        didSet {
            // Set comment data
            commentLabel.text = update["text"] as? String
            
            // Load full commenter User
            let commenter = update["author"] as! PFUser
            commenter.fetchInBackground { (user: PFObject?, error: Error?) in
                if error == nil {
                    // Set commenter data
                    self.usernameLabel.text = user?["username"] as? String
                    let iconUrl = user?["portrait"] as? PFFile
                   
                    // Fetch commenter icon
                    iconUrl?.getDataInBackground(block: { (image: Data?, error: Error?) in
                        self.commenterIcon.image = UIImage(data: image!)
                    })
                }
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Style view image(s)
        commenterIcon.layer.cornerRadius = commenterIcon.frame.height / 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

