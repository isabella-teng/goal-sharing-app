//
//  UserSearchCell.swift
//  Goals
//
//  Created by Isabella Teng on 7/26/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class UserSearchCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    
    var user: PFUser! {
        didSet {
            usernameLabel.text = user.username
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
