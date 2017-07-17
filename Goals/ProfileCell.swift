//
//  ProfileCell.swift
//  Goals
//
//  Created by Isabella Teng on 7/11/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse
import ParseUI

protocol ProfileCellDelegate: class {
    func profileCell(_ profileCell: ProfileCell, didTap goal: PFObject)
}

class ProfileCell: UITableViewCell {

    @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    weak var delegate: ProfileCellDelegate?
    
    var goal: PFObject! {
        didSet {
            titleLabel.text = goal["title"] as? String
        }
    }
    
    func didTapCell(_ sender: UITapGestureRecognizer) {
        // Call method on delegate
        delegate?.profileCell(self, didTap: goal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellBackground.layer.cornerRadius = 10
        let cellTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapCell(_:)))

        cellBackground.addGestureRecognizer(cellTapGestureRecognizer)
        cellBackground.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }

}
