//
//  MessageCell.swift
//  Goals
//
//  Created by Gerardo Parra on 8/8/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var messageBackground: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var senderIcon: UIImageView!
    
    var message: [String: Any] = [:] {
        didSet {
            messageLabel.text = message["text"] as? String
            
            if message["source"] as! String != "self" {
                senderIcon.layer.cornerRadius = senderIcon.frame.height / 2
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageBackground.layer.cornerRadius = 15
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
