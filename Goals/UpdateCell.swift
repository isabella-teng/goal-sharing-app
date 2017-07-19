//
//  UpdateCell.swift
//  Goals
//
//  Created by Gerardo Parra on 7/18/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse

class UpdateCell: UITableViewCell {

    @IBOutlet weak var rightBackground: UIView!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var nodeView: UIView!
    
    var data: [String: Any] = [:] {
        didSet {
            rightLabel.text = (data["text"] as! String)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        rightBackground.layer.cornerRadius = 10
        nodeView.layer.cornerRadius = nodeView.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
