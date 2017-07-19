//
//  InfoCell.swift
//  Goals
//
//  Created by Gerardo Parra on 7/19/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell {

    @IBOutlet weak var progressBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        progressBackground.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}