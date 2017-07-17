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
    func feedCell(_ feedCell: FeedCell, didTap update: PFObject)
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
    
    
    var update: PFObject! {
        didSet {
            self.titleLabel.text = update["text"] as? String
            let author = update["author"] as! PFUser
            self.authorLabel.text = author.username
            
            if author.username == "isabella" {
                self.userProfPic.image = #imageLiteral(resourceName: "isabella")
            } else if author.username == "gerardo" {
                self.userProfPic.image = #imageLiteral(resourceName: "gerardo")
            } else if author.username == "josh" {
                self.userProfPic.image = #imageLiteral(resourceName: "josh")
            }

            self.goalTitleLabel.text = update["goalTitle"] as? String
            
            let dateUpdated = update.createdAt! as Date
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "MM-dd-yy"
            self.dateLabel.text = String(dateFormat.string(from: dateUpdated))
            
            
            userProfPic.layer.cornerRadius = 20
            userProfPic.clipsToBounds = true
            
            
            
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
            
        }
    }
    

    func didTapCell(_ sender: UITapGestureRecognizer) {
        // Call method on delegate
        delegate?.feedCell(self, didTap: update)
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
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Add tap gesture recognizer to red area in cell
        let cellTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapCell(_:)))
        cellBackground.addGestureRecognizer(cellTapGestureRecognizer)
        cellBackground.isUserInteractionEnabled = true
        
        cellBackground.layer.cornerRadius = 10
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
