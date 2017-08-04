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
    @IBOutlet weak var detailBackground: UIView!
    @IBOutlet weak var detailEdges: UIView!
    
    @IBOutlet weak var startDateToNow: UILabel!
    @IBOutlet weak var remainingDays: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var streakCount: UILabel!
    
    weak var otherDelegate: ProfileCellDelegate?
    
    var goal: PFObject! {
        didSet {
            titleLabel.text = goal["title"] as? String
            
            let category = goal["categories"] as! String
            if category == "Education" {
                cellBackground.backgroundColor = UIColor(red: 0.95, green: 0.45, blue: 0.45, alpha: 1.0)
                detailBackground.backgroundColor = UIColor(red: 0.85, green: 0.35, blue: 0.35, alpha: 1.0)
                detailEdges.backgroundColor = detailBackground.backgroundColor
            } else if category == "Money" {
                cellBackground.backgroundColor = UIColor(red: 0.45, green: 0.85, blue: 0.55, alpha: 1.0)
                detailBackground.backgroundColor = UIColor(red: 0.35, green: 0.75, blue: 0.45, alpha: 1.0)
                detailEdges.backgroundColor = detailBackground.backgroundColor
            } else if category == "Spiritual" {
                cellBackground.backgroundColor = UIColor(red: 0.60, green: 0.45, blue: 0.85, alpha: 1.0)
                detailBackground.backgroundColor = UIColor(red: 0.50, green: 0.35, blue: 0.75, alpha: 1.0)
                detailEdges.backgroundColor = detailBackground.backgroundColor
            } else if category == "Health" {
                cellBackground.backgroundColor = UIColor(red: 0.45, green: 0.65, blue: 0.95, alpha: 1.0)
                detailBackground.backgroundColor = UIColor(red: 0.35, green: 0.55, blue: 0.85, alpha: 1.0)
                detailEdges.backgroundColor = detailBackground.backgroundColor
            } else if category == "Fun" {
                cellBackground.backgroundColor = UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1.0)
                detailBackground.backgroundColor = UIColor(red: 0.35, green: 0.35, blue: 0.35, alpha: 1.0)
                detailEdges.backgroundColor = detailBackground.backgroundColor
            }
            
            
            //Calculate days in between
            let startToCurrent = calculateDaysBetweenTwoDates(start: goal.createdAt!, end: Date())
            startDateToNow.text = "Started " + String(startToCurrent) + "d ago"
            
            let currentToCompletion = calculateDaysBetweenTwoDates(start: Date(), end: goal["completionDate"] as! Date)
            
            
            if goal["isCompleted"] as! Bool == true {
                 let completedToCurrent = calculateDaysBetweenTwoDates(start: goal["actualCompletionDate"] as! Date, end: Date())
                remainingDays.text = "Completed " + String(completedToCurrent) + "d ago"
                progressView.progress = 1
            } else {
                 remainingDays.text = String(currentToCompletion) + "d remaining"
                let startToCompletion = calculateDaysBetweenTwoDates(start: goal.createdAt!, end: goal["completionDate"] as! Date)
                progressView.progress = Float(startToCurrent) / Float(startToCompletion)
            }
            
            
            //check if last update date is less than 24 hours since current time
            if let lastUpdate = goal["lastUpdateDay"] as? Date {
                if let diff = Calendar.current.dateComponents([.hour], from: lastUpdate, to: Date()).hour, diff > 1 {
                    goal.setValue(0, forKey: "streakCount")
                }
            }
            
            
            
            streakCount.text = String(goal["streakCount"] as! Int)
            
        }
    }
    
    private func calculateDaysBetweenTwoDates(start: Date, end: Date) -> Int {
        
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: .day, in: .era, for: start) else {
            return 0
        }
        guard let end = currentCalendar.ordinality(of: .day, in: .era, for: end) else {
            return 0
        }
        return end - start
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
        detailBackground.layer.cornerRadius = 10
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
    
//    override func draw(_ rect: CGRect) {
//        color.set()
//        UIBezierPath(ovalIn: rect).fill()
//    }
}
