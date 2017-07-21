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
    @IBOutlet weak var captionBackground: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    
    var data: [String: Any] = [:] {
        didSet {
            let currentType = data["type"] as! String
            if currentType == "image" {
                cellImage.image = data["image"] as? UIImage
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellImage.layer.cornerRadius = 10
        captionBackground.layer.cornerRadius = 10
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        nodeView.layer.cornerRadius = nodeView.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
