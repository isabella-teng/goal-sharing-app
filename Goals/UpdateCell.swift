//
//  UpdateCell.swift
//  Goals
//
//  Created by Gerardo Parra on 7/18/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse

protocol TimelineUpdateCellDelegate: class {
    func timelineUpdateCell(_ updateCell: UpdateCell, didTap update: PFObject, tapped media: [String: Any]?)
}

class UpdateCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, MediaCellDelegate {
    
    @IBOutlet weak var updateBackground: UIView!
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentBackground: UIView!
    @IBOutlet weak var commenterIcon: UIImageView!
    @IBOutlet weak var commenterLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nodeView: UIView!
    
    @IBOutlet weak var mediaHeight: NSLayoutConstraint!
    @IBOutlet weak var mediaPosition: NSLayoutConstraint!
    
    weak var delegate: TimelineUpdateCellDelegate?
    
    var parent: UIViewController?
    
    var media: [[String: Any]] = []
    var update: PFObject? = nil {
        didSet {
            // Style update based on type
            let updateType = update?["type"] as! String
            if updateType == "positive" {
                updateBackground.backgroundColor = UIColor(red:0.50, green:0.85, blue:0.60, alpha:1.0)
            } else if updateType == "negative" {
                updateBackground.backgroundColor = UIColor(red:0.95, green:0.45, blue:0.45, alpha:1.0)
            } else {
                updateBackground.backgroundColor = UIColor(red: 0.45, green: 0.50, blue: 0.90, alpha: 1.0)
            }
            
            updateLabel.text = update?["text"] as? String
            
            // Set timestamp
            let date = update?.createdAt!
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "M/d/yyyy"
            dateLabel.text = String(dateFormat.string(from: date!))
            
            // Set up comment view
            let comments = update?["comments"] as! [[String: Any]]
            if comments.count == 0 {
                // Hide comment view if no comments
                commentBackground.isHidden = true
            } else {
                commentBackground.isHidden = false
                
                // Populate view with most recent comment
                let comment = comments[comments.count - 1]
                commentLabel.text = comment["text"] as? String
                
                let author = comment["author"] as! PFUser
                author.fetchIfNeededInBackground(block: { (fetchedUser: PFObject?, error: Error?) in
                    if error == nil {
                        let author = fetchedUser as? PFUser
                        self.commenterLabel.text = author?.username
                        
                        // Fetch commenter icon
                        let profpic = author?["portrait"] as? PFFile
                        profpic?.getDataInBackground { (imageData: Data?, error: Error?) in
                            self.commenterIcon.image = UIImage(data: imageData!)
                        }
                    } else {
                        print(error?.localizedDescription as Any)
                    }
                })
            }
            
            let activityMedia = update?["activity"] as! [[String: Any]]
            if activityMedia.count == 0 {
                collectionView.isHidden = true
                mediaHeight.constant = 0
                if comments.count == 0 {
                    mediaPosition.constant = -71.5
                } else {
                    mediaPosition.constant = 0
                }
            } else {
                collectionView.isHidden = false
                mediaHeight.constant = 294
                media = activityMedia
                if comments.count == 0 {
                    mediaPosition.constant = -71.5
                    
                    let count = UIView(frame: CGRect(x: 150, y: 66, width: 25, height: 20))
                    count.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
                    count.layer.cornerRadius = count.frame.height / 2
                    
                    let countLabel = UILabel(frame: CGRect(x: 0, y: 0, width: count.frame.width, height: count.frame.height))
                    countLabel.textColor = UIColor.white
                    countLabel.font = UIFont(name: "HelveticaNeue", size: 14)
                    countLabel.textAlignment = NSTextAlignment.center
                    countLabel.text = String(activityMedia.count)
                    
                    count.addSubview(countLabel)
                    self.addSubview(count)
                } else {
                    mediaPosition.constant = 15
                    
                    let count = UIView(frame: CGRect(x: 150, y: 100 + ((comments[comments.count - 1]["text"] as! String).characters.count % 25 * 10), width: 25, height: 20))
                    count.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
                    count.layer.cornerRadius = count.frame.height / 2
                    
                    let countLabel = UILabel(frame: CGRect(x: 0, y: 0, width: count.frame.width, height: count.frame.height))
                    countLabel.textColor = UIColor.white
                    countLabel.font = UIFont(name: "HelveticaNeue", size: 14)
                    countLabel.textAlignment = NSTextAlignment.center
                    countLabel.text = String(activityMedia.count)
                    
                    count.addSubview(countLabel)
                    self.addSubview(count)
                }
            }
        }
    }
    
    func didTapUpdate(_ sender: UITapGestureRecognizer) {
        delegate?.timelineUpdateCell(self, didTap: update!, tapped: nil)
    }
    
    func mediaCell(_ mediaCell: MediaCell, didTap data: [String : Any]) {
        print(data)
        delegate?.timelineUpdateCell(self, didTap: update!, tapped: data)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set up collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.layer.cornerRadius = 10
        
        // Style cell images and views
        updateBackground.backgroundColor = UIColor.white
        updateBackground.layer.cornerRadius = 10
        commentBackground.layer.cornerRadius = 10
        nodeView.layer.cornerRadius = nodeView.frame.height / 2
        commenterIcon.layer.cornerRadius = commenterIcon.frame.height / 2
        
        let cellTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapUpdate(_:)))
        updateBackground.addGestureRecognizer(cellTapGestureRecognizer)
        updateBackground.isUserInteractionEnabled = true
    }
    
    
    // Return collectionView item count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return media.count
    }
    
    // Format collectionView cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCell", for: indexPath) as! MediaCell
        
        cell.delegate = self
        cell.data = media[indexPath.item]

        return cell
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
