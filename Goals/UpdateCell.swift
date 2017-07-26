//
//  UpdateCell.swift
//  Goals
//
//  Created by Gerardo Parra on 7/18/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse

class UpdateCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var rightBackground: UIView!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var nodeView: UIView!
    @IBOutlet weak var commentBackground: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var mediaPostion: NSLayoutConstraint!
    @IBOutlet weak var mediaHeight: NSLayoutConstraint!
    
    var media: [[String: Any]] = []
    var update: PFObject? = nil {
        didSet {
            let updateType = update?["type"] as! String
            if updateType == "positive" {
                rightBackground.backgroundColor = UIColor(red:0.50, green:0.85, blue:0.60, alpha:1.0)
            } else if updateType == "negative" {
                rightBackground.backgroundColor = UIColor(red:0.95, green:0.45, blue:0.45, alpha:1.0)
            } else {
                rightBackground.backgroundColor = UIColor(red: 0.45, green: 0.50, blue: 0.90, alpha: 1.0)
            }
            
            rightLabel.text = update?["text"] as? String
            
            let date = update?.createdAt!
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "M/d/yyyy"
            dateLabel.text = String(dateFormat.string(from: date!))
            
            let comments = update?["comments"] as! [[String: Any]]
            if comments.count == 0 {
                mediaPostion.constant = -71.5
                commentBackground.isHidden = true
            } else {
                mediaPostion.constant = 8
                commentBackground.isHidden = false
                let comment = comments[comments.count - 1]
                captionLabel.text = comment["text"] as? String
                
                let author = comment["author"] as! PFUser
                author.fetchIfNeededInBackground(block: { (fetchedUser: PFObject?, error: Error?) in
                    if error == nil {
                        let author = fetchedUser as? PFUser
                        self.senderLabel.text = author?.username
                        
                        if let profpic = author?["portrait"] as? PFFile {
                            profpic.getDataInBackground { (imageData: Data?, error: Error?) in
                                if error == nil {
                                    let profImage = UIImage(data: imageData!)
                                    self.profileImage.image = profImage
                                }
                            }
                        }
                    }
                })
            }
            
            let activityMedia = update?["activity"] as! [[String: Any]]
            print(activityMedia)
            //let pictures = update?["pictures"] as! [[String: Any]]
            if activityMedia.count == 0 {
                collectionView.isHidden = true
                mediaHeight.constant = 0
                mediaPostion.constant = 0
            } else {
                collectionView.isHidden = false
                mediaHeight.constant = 190
                mediaPostion.constant = 8
                media = activityMedia
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.layer.cornerRadius = 10
        
        rightBackground.backgroundColor = UIColor.white
        rightBackground.layer.cornerRadius = 10
        commentBackground.layer.cornerRadius = 10
        nodeView.layer.cornerRadius = nodeView.frame.height / 2
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return media.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCell", for: indexPath) as! MediaCell
        
        cell.data = media[indexPath.item]
        
        return cell
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
