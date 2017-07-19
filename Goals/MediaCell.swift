//
//  MediaCell.swift
//  Goals
//
//  Created by Gerardo Parra on 7/18/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit

class MediaCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var nodeView: UIView!
    
    var data: [String: Any] = [:] {
        didSet {
            cellImage.image = data["image"] as? UIImage
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellImage.layer.cornerRadius = 10
        nodeView.layer.cornerRadius = nodeView.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
