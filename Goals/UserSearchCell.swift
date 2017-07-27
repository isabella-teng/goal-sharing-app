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
    
    weak var delegate: UserSearchCellDelegate?
    
    var user: PFUser! {
        didSet {
            usernameLabel.text = user.username
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
        
        cellBackground.backgroundColor = UIColor(red:0.97, green:0.88, blue:0.80, alpha:1.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
