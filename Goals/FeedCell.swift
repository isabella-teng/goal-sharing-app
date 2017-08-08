//
//  FeedCell.swift
//  Goals
//
//  Created by Gerardo Parra on 7/11/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse
import DateToolsSwift

protocol FeedCellDelegate: class {
    func feedCell(_ feedCell: FeedCell, didTap update: PFObject, tappedComment: Bool, tappedCamera: Bool, tappedUser: PFUser?)
}

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var updateImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var userProfPic: UIImageView!
    @IBOutlet weak var goalTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var goalDateLabel: UILabel!
    @IBOutlet weak var goalCellBg: UIView!
    @IBOutlet weak var goalCellEdges: UIView!
    @IBOutlet weak var interactionBackground: UIView!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var updateDescription: UILabel!
    
    @IBOutlet weak var updateImageHeight: NSLayoutConstraint!
    @IBOutlet weak var goalCellMargin: NSLayoutConstraint!
    
    
    weak var delegate : FeedCellDelegate?
    
    var author: PFUser? = nil
    var likesArray: [PFUser]? = nil
    var liked = false
    var update: PFObject! {
        didSet {
            self.titleLabel.text = update["text"] as? String
            self.author = update["author"] as? PFUser
            self.authorLabel.text = author?.username
            self.goalTitleLabel.text = update["goalTitle"] as? String
            
            if let profpic = author?["portrait"] as? PFFile {
                profpic.getDataInBackground { (imageData: Data?, error: Error?) in
                    if error == nil {
                        let profImage = UIImage(data: imageData!)
                        self.userProfPic.image = profImage
                    }
                }
            }
            
            // Change background of cell based on the good or bad update: http://uicolor.xyz/#/rgb-to-ui
            let typeString = update["type"] as! String
            if typeString == "positive" {
                cellBackground.backgroundColor = UIColor(red:0.50, green:0.85, blue:0.60, alpha:1.0)
                goalCellBg.backgroundColor = UIColor(red: 0.40, green: 0.75, blue: 0.45, alpha: 1.0)
                goalCellEdges.backgroundColor = goalCellBg.backgroundColor
                updateDescription.text = "posted an update:"
            } else if typeString == "negative" {
                cellBackground.backgroundColor = UIColor(red:0.95, green:0.45, blue:0.45, alpha:1.0)
                goalCellBg.backgroundColor = UIColor(red: 0.85, green: 0.30, blue: 0.30, alpha: 1.0)
                goalCellEdges.backgroundColor = goalCellBg.backgroundColor
                updateDescription.text = "posted an update:"
            } else if typeString == "Complete" {
                cellBackground.backgroundColor = UIColor(red:0.93, green:0.71, blue:0.13, alpha:1.0)
                goalCellBg.backgroundColor = UIColor(red:0.93, green:0.61, blue:0.12, alpha:1.0)
                goalCellEdges.backgroundColor = goalCellBg.backgroundColor
                update["image"] = Update.getPFFileFromImage(image: #imageLiteral(resourceName: "ballons"))
                updateDescription.text = "completed a goal!"
                titleLabel.text = update["goalTitle"] as? String
                goalTitleLabel.text = "Congratulate " + (author?.username)!.capitalized + "!"
            } else {
                cellBackground.backgroundColor = UIColor(red: 0.45, green: 0.50, blue: 0.90, alpha: 1.0)
                goalCellBg.backgroundColor = UIColor(red: 0.35, green: 0.40, blue: 0.70, alpha: 1.0)
                goalCellEdges.backgroundColor = goalCellBg.backgroundColor
                updateDescription.text = "started a new goal!"
            }
            
            if let picture = update["image"] as? PFFile {
                updateImageHeight.constant = 300
                goalCellMargin.constant = 15
                picture.getDataInBackground(block: { (data: Data?, error: Error?) in
                    if error == nil {
                        let image = UIImage(data: data!)
                        self.updateImage.image = image
                    }
                })
            } else {
                updateImageHeight.constant = 0
                goalCellMargin.constant = 0
            }
            
            let dateUpdated = update.createdAt! as Date
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "MM.dd.yy"
            dateFormat.dateStyle = .short
            dateFormat.timeStyle = .none
            self.dateLabel.text = dateUpdated.shortTimeAgoSinceNow
            
            let goalDateUpdated = update["goalDate"] as! Date
            self.goalDateLabel.text = String(dateFormat.string(from: goalDateUpdated))
            
            
            likesArray = update["likes"] as? [PFUser]
            
            let currentLikeCount = update["likeCount"] as! Int
            self.favoriteCount.text = String(currentLikeCount)
            
            let commentLikeCount = update["commentCount"] as! Int
            self.commentCount.text = String(commentLikeCount)
            
            if isLiked() {
                self.favoriteButton.isSelected = true
                liked = true
            } else {
                self.favoriteButton.isSelected = false
                liked = false
            }
        }
    }
    

    func didTapCell(_ sender: UITapGestureRecognizer) {
        // Call method on delegate
        delegate?.feedCell(self, didTap: update, tappedComment: false, tappedCamera: false, tappedUser: nil)
    }
    
    func didTapCommentButton(_ sender: UITapGestureRecognizer) {
        delegate?.feedCell(self, didTap: update, tappedComment: true, tappedCamera: false, tappedUser: nil)
    }
    
    func didTapCameraButton(_ sender: UITapGestureRecognizer) {
        delegate?.feedCell(self, didTap: update, tappedComment: false, tappedCamera: true, tappedUser: nil)
    }
    
    
    func isLiked() -> Bool {
        for liker in likesArray! {
            if PFUser.current()?.objectId! == liker.objectId {
                return true
            }
        }
        return false
    }
    
    func removeLike() {
        for (index, liker) in likesArray!.enumerated() {
            if PFUser.current()?.objectId == liker.objectId {
                likesArray?.remove(at: index)
            }
        }
    }
    
    @IBAction func onFavorite(_ sender: Any) {
        if liked {
            favoriteButton.isSelected = false
            update.incrementKey("likeCount", byAmount: -1)
            liked = false
            removeLike()
        } else {
            favoriteButton.isSelected = true
            update.incrementKey("likeCount", byAmount: 1)
            liked = true
            likesArray!.append(PFUser.current()!)
        }
        
        favoriteCount.text = String(update["likeCount"] as! Int)
        
        update["likes"] = likesArray
        update.saveInBackground()
    }
    
    
    @IBAction func didTapUser(_ sender: Any) {
        delegate?.feedCell(self, didTap: update, tappedComment: false, tappedCamera: false, tappedUser: author)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Add tap gesture recognizer to red area in cell
        let cellTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapCell(_:)))
        cellBackground.addGestureRecognizer(cellTapGestureRecognizer)
        cellBackground.isUserInteractionEnabled = true
        
        let commentTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapCommentButton(_:)))
        commentButton.addGestureRecognizer(commentTapGestureRecognizer)
        commentButton.isUserInteractionEnabled = true
        
        let cameraTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapCameraButton(_:)))
        videoButton.addGestureRecognizer(cameraTapGestureRecognizer)
        videoButton.isUserInteractionEnabled = true
        
        cellBackground.layer.cornerRadius = 10
        goalCellBg.layer.cornerRadius = 10
        interactionBackground.layer.cornerRadius = 10
        userProfPic.layer.cornerRadius = 20
        updateImage.layer.cornerRadius = 10
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
