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
    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var detailsBackground: UIView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var startingTimeLabel: UILabel!
    @IBOutlet weak var remainingDaysLabel: UILabel!
    
    
    
    weak var delegate: GoalCategoryCellDelegate?
    
    var author: PFUser? = nil
    var goal: PFObject! {
        didSet {
            self.goalTitle.text = (goal["title"] as? String)!
            
            self.author = goal["author"] as? PFUser
            self.usernameLabel.text = author?.username
            
            let iconURL = author?["portrait"] as? PFFile
            iconURL?.getDataInBackground { (image: Data?, error: Error?) in
                self.profPic.image = UIImage(data: image!)
            }
            
            //Calculate days in between
            let startToCurrent = calculateDaysBetweenTwoDates(start: goal.createdAt!, end: Date())
            startingTimeLabel.text = "Started " + String(startToCurrent) + "d ago"
            
            let currentToCompletion = calculateDaysBetweenTwoDates(start: Date(), end: goal["completionDate"] as! Date)
            
            if goal["isCompleted"] as! Bool == true {
                let completedToCurrent = calculateDaysBetweenTwoDates(start: goal["actualCompletionDate"] as! Date, end: Date())
                remainingDaysLabel.text = "Completed " + String(completedToCurrent) + "d ago"
                progressBar.progress = 1
            } else {
                remainingDaysLabel.text = String(currentToCompletion) + "d remaining"
                let startToCompletion = calculateDaysBetweenTwoDates(start: goal.createdAt!, end: goal["completionDate"] as! Date)
                progressBar.progress = Float(startToCurrent) / Float(startToCompletion)
            }
            
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

    
    func didTapCell(_ sender: UITapGestureRecognizer) {
        delegate?.goalCategoryCell(self, didTap: goal)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        profPic.layer.cornerRadius = profPic.frame.height / 2
        detailsBackground.layer.cornerRadius = 10
        
        cellBackground.layer.cornerRadius = 10
        let cellTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapCell(_:)))
        cellBackground.addGestureRecognizer(cellTapGestureRecognizer)
        cellBackground.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
