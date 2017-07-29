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
import SwipeCellKit

protocol ProfileCellDelegate: class {
    func profileCell(_ profileCell: ProfileCell, didTap goal: PFObject)
}

class ProfileCell: SwipeTableViewCell {

    @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    weak var otherDelegate: ProfileCellDelegate?
    
    var goal: PFObject! {
        didSet {
            titleLabel.text = goal["title"] as? String
            
            let category = goal["categories"] as! String
            print(category)
            if category == "Education" {
                cellBackground.backgroundColor = UIColor(red: 0.95, green: 0.45, blue: 0.45, alpha: 1.0)
            } else if category == "Money" {
                cellBackground.backgroundColor = UIColor(red: 0.45, green: 0.85, blue: 0.55, alpha: 1.0)
            } else if category == "Spiritual" {
                cellBackground.backgroundColor = UIColor(red: 0.60, green: 0.45, blue: 0.85, alpha: 1.0)
            } else if category == "Health" {
                cellBackground.backgroundColor = UIColor(red: 0.45, green: 0.65, blue: 0.95, alpha: 1.0)
            } else if category == "Fun" {
                cellBackground.backgroundColor = UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1.0)
            }
        }
    }
    
    var animator: Any?
    
    var indicatorView = IndicatorView(frame: .zero)
    
    var unread = false {
        didSet {
            indicatorView.transform = unread ? CGAffineTransform.identity : CGAffineTransform.init(scaleX: 0.001, y: 0.001)
        }
    }

    
    func didTapCell(_ sender: UITapGestureRecognizer) {
        // Call method on delegate
        otherDelegate?.profileCell(self, didTap: goal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupIndicatorView()
        
        cellBackground.layer.cornerRadius = 10
        let cellTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapCell(_:)))

        cellBackground.addGestureRecognizer(cellTapGestureRecognizer)
        cellBackground.isUserInteractionEnabled = true
    }
    
    func setupIndicatorView() {
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.color = tintColor
        indicatorView.backgroundColor = .clear
        contentView.addSubview(indicatorView)
        
        let size: CGFloat = 12
        indicatorView.widthAnchor.constraint(equalToConstant: size).isActive = true
        indicatorView.heightAnchor.constraint(equalTo: indicatorView.widthAnchor).isActive = true
        indicatorView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

class IndicatorView: UIView {
    var color = UIColor.clear {
        didSet { setNeedsDisplay() }
    }
    
    override func draw(_ rect: CGRect) {
        color.set()
        UIBezierPath(ovalIn: rect).fill()
    }
}
