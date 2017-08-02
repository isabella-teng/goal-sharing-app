//
//  UserSearchCell.swift
//  Goals
//
//  Created by Isabella Teng on 7/26/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse
import ParseUI

protocol UserSearchCellDelegate: class {
    func userSearchCell(_ userCell: UserSearchCell, didTap user: PFUser)
}

class UserSearchCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var userProfPic: PFImageView!
    
    weak var delegate: UserSearchCellDelegate?
    
//    var userImage: UIImage! {
//        didSet {
//            self.userProfPic.image = userImage
//        }
//    }
    
    var user: PFUser! {
        didSet {
            usernameLabel.text = user.username
            if let profPic = user["portrait"] as? PFFile {
                profPic.getDataInBackground{ (imageData: Data?, error: Error?) in
                    if error == nil {
                        let profImage = UIImage(data: imageData!)
                        self.userProfPic.image = profImage
                    }
                }
            } else { //default image
                userProfPic.image = UIImage(named: "default")
            }
        }
    }
    
    func didTapCell(_ sender: UITapGestureRecognizer) {
        delegate?.userSearchCell(self, didTap: user)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let cellTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapCell(_:)))
        cellBackground.addGestureRecognizer(cellTapGestureRecognizer)
        cellBackground.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}


//    
//    cell.contentView.backgroundColor = UIColor.clear
//    
//    let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 20, height: 120))
//    
//    whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
//    whiteRoundedView.layer.masksToBounds = false
//    whiteRoundedView.layer.cornerRadius = 2.0
//    whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
//    whiteRoundedView.layer.shadowOpacity = 0.2
//    
//    cell.contentView.addSubview(whiteRoundedView)
//    cell.contentView.sendSubview(toBack: whiteRoundedView)
//    
//    return cell
//}
