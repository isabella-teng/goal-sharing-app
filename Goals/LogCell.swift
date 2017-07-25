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
    @IBOutlet weak var dateLabel: UILabel!
    
    
    var update: PFObject! {
        didSet {
            self.titleLabel.text = update["text"] as? String
            
            //let dateUpdated = update.createdAt! as Date
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "MM.dd.yy"
            let updateDate = update.createdAt as! Date
            self.dateLabel.text = String("Updated on " + dateFormat.string(from: updateDate))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellBackground.layer.cornerRadius = 10
        cellBackground.backgroundColor = UIColor(red:0.99, green:0.77, blue:0.64, alpha:1.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

