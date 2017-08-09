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
    
    var message: [String: Any] = [:] {
        didSet {
            messageLabel.text = message["text"] as? String
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
