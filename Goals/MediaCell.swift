//
//  MediaCell.swift
//  Goals
//
//  Created by Gerardo Parra on 7/20/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse

class MediaCell: UICollectionViewCell {
    
    var data: [String: Any] = [:] {
        didSet {
            if let urlString = data["image"] as? PFFile {
                urlString.getDataInBackground { (imageData: Data?, error: Error?) in
                    if error == nil {
                        let profImage = UIImage(data: imageData!)
                        self.mediaImage.image = profImage
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var mediaImage: UIImageView!
}
