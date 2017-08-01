//
//  ContainerCell.swift
//  Goals
//
//  Created by Josh Olumese on 8/1/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse
import ParseUI

protocol ContainerCellDelegate: class {
    func containerCell(_ containerCell: ContainerCell, didTap goal: PFObject)
}

class ContainerCell: UITableViewCell {
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    weak var delegate: ContainerCellDelegate?
    
    var author: PFUser? = nil
    var goal: PFObject! {
        didSet {
            self.author = goal["author"] as? PFUser
            self.usernameLabel.text = author?.username
            let iconURL = author?["portrait"] as? PFFile
            iconURL?.getDataInBackground { (image: Data?, error: Error?) in
                self.profilePic.image = UIImage(data: image!)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
