//
//  CompletedCell.swift
//  Goals
//
//  Created by Gerardo Parra on 8/7/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit

class CompletedCell: UITableViewCell {

    @IBOutlet weak var nodeView: UIView!
    @IBOutlet weak var labelBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nodeView.layer.cornerRadius = nodeView.frame.height / 2
        labelBackground.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
