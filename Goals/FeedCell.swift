//
//  FeedCell.swift
//  Goals
//
//  Created by Gerardo Parra on 7/11/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse

protocol FeedCellDelegate: class {
    func feedCell(_ feedCell: FeedCell, didTap update: PFObject, tappedComment: Bool, tappedCamera: Bool, tappedUser: PFUser?)
}

class FeedCell: UITableViewCell {
    weak var delegate : FeedCellDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var userProfPic: UIImageView!
    @IBOutlet weak var goalTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var author: PFUser? = nil
    var update: PFObject! {
        didSet {
            self.titleLabel.text = update["text"] as? String
            self.author = update["author"] as? PFUser
            self.authorLabel.text = author?.username
            
            if author?.username == "isabella" {
                self.userProfPic.image = #imageLiteral(resourceName: "isabella")
            } else if author?.username == "gerardo" {
                self.userProfPic.image = #imageLiteral(resourceName: "gerardo")
            } else if author?.username == "josh" {
                self.userProfPic.image = #imageLiteral(resourceName: "josh")
            }

            self.goalTitleLabel.text = update["goalTitle"] as? String
            
            let dateUpdated = update.createdAt! as Date
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "MM-dd-yy"
            self.dateLabel.text = String(dateFormat.string(from: dateUpdated))
            
            
            userProfPic.layer.cornerRadius = 20
            userProfPic.clipsToBounds = true
            
            
            //FIX SMALL BUG WHEN NO GOALS THIS CRASHES HERE
            let currentLikeCount = update["likeCount"] as! Int
            if (currentLikeCount != 0) {
                self.favoriteCount.text = String(describing: update["likeCount"]!)
            }
            
            let liked = update.value(forKey: "liked") as! Bool
            
            if liked {
                self.favoriteButton.isSelected = true
            } else {
                self.favoriteButton.isSelected = false
            }
            
            //change background of cell based on the good or bad update
            //http://uicolor.xyz/#/rgb-to-ui
            
            let typeString = update["type"] as! String
            if typeString == "Good update" {
                cellBackground.backgroundColor = UIColor(red:0.50, green:0.91, blue:0.67, alpha:1.0)
            } else if typeString == "Bad update" {
                cellBackground.backgroundColor = UIColor(red:0.96, green:0.48, blue:0.48, alpha:1.0)
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
    
    @IBAction func onFavorite(_ sender: Any) {
        var liked = update["liked"] as! Bool
        
        let currentUser = PFUser.current()
        var likesArray = update["likes"] as! [PFUser]
        
        if !liked {
            favoriteButton.isSelected = true
            update.incrementKey("likeCount", byAmount: 1)
            liked = true
            update["liked"] = true
            likesArray.append(currentUser!)
            
            
        } else {
            favoriteButton.isSelected = false
            update.incrementKey("likeCount", byAmount: -1)
            liked = false
            update["liked"] = false
            likesArray = likesArray.filter { $0 != PFUser.current() }
        }
        favoriteCount.text = String(describing: update["likeCount"]!)
        
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
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
