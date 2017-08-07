//
//  CategoryCell.swift
//  Goals
//
//  Created by Isabella Teng on 8/1/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit

protocol CategoryCellDelegate: class {
    func categoryCell(_ categoryCell: CategoryCell, didTap categoryName: String)
}

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    weak var delegate: CategoryCellDelegate?

    func didTapCell(_ sender: UITapGestureRecognizer) {
        delegate?.categoryCell(self, didTap: categoryLabel.text!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let cellTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapCell(_:)))
        cellBackground.addGestureRecognizer(cellTapGestureRecognizer)
        cellBackground.isUserInteractionEnabled = true
        
        cellBackground.layer.cornerRadius = 5
        categoryIcon.tintColor = categoryLabel.textColor
    }
}

