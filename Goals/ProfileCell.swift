//
//  ProfileCell.swift
//  Goals
//
//  Created by Isabella Teng on 7/11/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileCell: UITableViewCell {

    @IBOutlet weak var goalTitleLabel: UILabel!
    
    var goalTitle: PFObject! {
        didSet {
            self.goalTitleLabel.text = goalTitle["title"] as? String
            self.goalTitleLabel.reloadInputViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
