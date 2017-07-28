//
//  CategoryCell.swift
//  Goals
//
//  Created by Isabella Teng on 7/27/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit

protocol CategoryCellDelegate: class {
    func categoryCell(_ categoryCell: CategoryCell, didTap categoryName: String)
}

class CategoryCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var cellBackground: UIView!
    
    weak var delegate: CategoryCellDelegate?
    
    
    func didTapCell(_ sender: UITapGestureRecognizer) {
        delegate?.categoryCell(self, didTap: categoryLabel.text!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let cellTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapCell(_:)))
        cellBackground.addGestureRecognizer(cellTapGestureRecognizer)
        cellBackground.isUserInteractionEnabled = true
        
        cellBackground.layer.cornerRadius = 15
        cellBackground.backgroundColor = UIColor(red:0.70, green:0.96, blue:0.84, alpha:1.0)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
