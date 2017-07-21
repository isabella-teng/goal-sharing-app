//
//  MediaCell.swift
//  Goals
//
//  Created by Gerardo Parra on 7/20/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit

class MediaCell: UICollectionViewCell {
    
    var data: [String: Any] = [:] {
        didSet {
            mediaImage.image = data["image"] as? UIImage
        }
    }

    @IBOutlet weak var mediaImage: UIImageView!
}
