//
//  UserSearchCell.swift
//  Goals
//
//  Created by Isabella Teng on 7/26/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse
import ParseUI

protocol UserSearchCellDelegate: class {
    func userSearchCell(_ userCell: UserSearchCell, didTap user: PFUser)
}

class UserSearchCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var userProfPic: PFImageView!
    @IBOutlet weak var activeCount: UILabel!
    @IBOutlet weak var completedCount: UILabel!
    
    weak var delegate: UserSearchCellDelegate?
    
    var user: PFUser! {
        didSet {
            usernameLabel.text = user.username
            if let profPic = user["portrait"] as? PFFile {
                profPic.getDataInBackground{ (imageData: Data?, error: Error?) in
                    if error == nil {
                        let profImage = UIImage(data: imageData!)
                        self.userProfPic.image = profImage
                    }
                }
            } else {
                userProfPic.image = #imageLiteral(resourceName: "default")
            }
            
            activeCount.text = "Active Goals: " + String(user["activeGoalCount"] as? Int ?? 0)
            completedCount.text = "Completed Goals: " + String(user["completedGoalCount"] as? Int ?? 0)
        }
    }
    
    func didTapCell(_ sender: UITapGestureRecognizer) {
        delegate?.userSearchCell(self, didTap: user)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let cellTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapCell(_:)))
        cellBackground.addGestureRecognizer(cellTapGestureRecognizer)
        cellBackground.isUserInteractionEnabled = true
        
        userProfPic.layer.cornerRadius = userProfPic.frame.height / 2
        cellBackground.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
