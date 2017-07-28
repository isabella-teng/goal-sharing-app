//
//  GoalCategoryCell.swift
//  Goals
//
//  Created by Isabella Teng on 7/27/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse
import ParseUI

protocol GoalCategoryCellDelegate: class {
    func goalCategoryCell(_ goalCategoryCell: GoalCategoryCell, didTap goal: PFObject)
}

class GoalCategoryCell: UITableViewCell {

    @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var goalTitle: UILabel!
    
    weak var delegate: GoalCategoryCellDelegate?
    
    var goal: PFObject! {
        didSet {
            goalTitle.text = (goal["title"] as? String)!
            
        }
    }
    
    func didTapCell(_ sender: UITapGestureRecognizer) {
        delegate?.goalCategoryCell(self, didTap: goal)
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

        // Configure the view for the selected state
    }

}
