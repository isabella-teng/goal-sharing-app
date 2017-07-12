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
    @IBOutlet weak var titleLabel: UILabel!
    
    //add reference to original post if an update, none if new goal
    
    var update: PFObject! {
        didSet {
            self.titleLabel.text = update["text"] as? String
            
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

