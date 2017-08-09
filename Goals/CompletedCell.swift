//
//  CompletedCell.swift
//  Goals
//
//  Created by Gerardo Parra on 8/7/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse

class CompletedCell: UITableViewCell {

    @IBOutlet weak var nodeView: UIView!
    @IBOutlet weak var labelBackground: UIView!
    @IBOutlet weak var timestampLabel: UILabel!
    
    var goal: PFObject? = nil {
        didSet {
            // Set timestamp
            let date = goal?["actualCompletionDate"] as! Date
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "MMM d, yyyy"
            let timestampString = String(dateFormat.string(from: date))
            timestampLabel.text = String("Completed " + timestampString!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nodeView.layer.cornerRadius = nodeView.frame.height / 2
        labelBackground.layer.cornerRadius = 10
    }
}
