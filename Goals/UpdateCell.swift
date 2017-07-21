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
    @IBOutlet weak var captionBackground: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data: [String: Any] = [:] {
        didSet {
            rightLabel.text = (data["text"] as! String)
        }
    }
    var media: [[String: Any]] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.layer.cornerRadius = 10
        
        rightBackground.layer.cornerRadius = 10
        captionBackground.layer.cornerRadius = 10
        nodeView.layer.cornerRadius = nodeView.frame.height / 2
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        
        media = [["image": #imageLiteral(resourceName: "isabella")], ["image": #imageLiteral(resourceName: "josh")], ["image": #imageLiteral(resourceName: "gerardo")]]
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
