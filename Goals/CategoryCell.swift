//
//  CategoryCell.swift
//  Goals
//
//  Created by Isabella Teng on 8/1/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    

    override func awakeFromNib() {
        
    }
    
    
    
}


//import UIKit
//
//protocol CategoryCellDelegate: class {
//    func categoryCell(_ categoryCell: CategoryCell, didTap categoryName: String)
//}
//
//class CategoryCell: UITableViewCell {
//
//    @IBOutlet weak var categoryLabel: UILabel!
//    @IBOutlet weak var cellBackground: UIView!
//    @IBOutlet weak var categoryIcon: UIImageView!
//
//    weak var delegate: CategoryCellDelegate?
//
//
//    func didTapCell(_ sender: UITapGestureRecognizer) {
//        delegate?.categoryCell(self, didTap: categoryLabel.text!)
//    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        let cellTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapCell(_:)))
//        cellBackground.addGestureRecognizer(cellTapGestureRecognizer)
//        cellBackground.isUserInteractionEnabled = true
//
//        cellBackground.layer.cornerRadius = 15
//
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//}
