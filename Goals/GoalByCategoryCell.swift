//
//  GoalByCategoryCell.swift
//  Goals
//
//  Created by Isabella Teng on 7/27/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class GoalByCategoryCell: UITableViewCell {

    @IBOutlet weak var goalCategoryLabel: UILabel!
    @IBOutlet weak var goalTitleLabel: UILabel!
    
    @IBOutlet weak var cellBackground: UIView!
    
    var goal: PFObject! {
        didSet {
            goalCategoryLabel.text = goal["categories"] as! String
            goalTitleLabel.text = goal["title"] as! String
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellBackground.backgroundColor = UIColor(red:0.85, green:0.97, blue:0.80, alpha:1.0)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
