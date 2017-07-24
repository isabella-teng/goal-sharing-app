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
    @IBOutlet weak var goalStartDateLabel: UILabel!
    @IBOutlet weak var dateImage: UIButton!
    
    
    var goal: PFObject! {
        didSet {
            goalTitle.text = goal["title"] as? String
            
            let dateCreated = goal.createdAt! as Date
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "MM.dd.yy"
            self.goalStartDateLabel.text = String("Began goal on " + dateFormat.string(from: dateCreated))

        }
    }
    
    func didTapCell(_ sender: UITapGestureRecognizer) {
        // Call method on delegate
        delegate?.goalCell(self, didTap: goal)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellBackground.layer.cornerRadius = 10
        
        let cellTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapCell(_:)))
        cellBackground.addGestureRecognizer(cellTapGestureRecognizer)
        cellBackground.isUserInteractionEnabled = true
        
        // Change close button tint
        let origImage = #imageLiteral(resourceName: "info")
        let tintedImage = origImage.withRenderingMode(.alwaysTemplate)
        dateImage.setImage(tintedImage, for: .normal)
        dateImage.tintColor = goalStartDateLabel.textColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
