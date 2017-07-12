//
//  FeedCell.swift
//  Goals
//
//  Created by Gerardo Parra on 7/11/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse

class FeedCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var cellBackground: UIView!
    
    var goal: PFObject! {
        didSet {
            self.titleLabel.text = goal["title"] as? String
            if let author = goal["author"] as? PFUser {
                authorLabel.text = author.username
            }
            //authorLabel.text = author.username
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellBackground.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
