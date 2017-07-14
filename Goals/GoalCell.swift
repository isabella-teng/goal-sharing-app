//
//  GoalCell.swift
//  Goals
//
//  Created by Isabella Teng on 7/13/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse
import ParseUI

protocol GoalCellDelegate: class {
    func goalCell(_ goalCell: GoalCell, didTap goal: PFObject)
}

class GoalCell: UITableViewCell {
    weak var delegate: GoalCellDelegate?
    
    @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var goalTitle: UILabel!

    
    var goal: PFObject! {
        didSet {
            goalTitle.text = goal["title"] as? String
        }
    }
    
    func didTapCell(_ sender: UITapGestureRecognizer) {
        //print("tapped")
        // Call method on delegate
        delegate?.goalCell(self, didTap: goal)
       //print(goal["objectId"])
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
