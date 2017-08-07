//
//  PeekViewViewController.swift
//  Goals
//
//  Created by Isabella Teng on 8/6/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit

class PeekViewViewController: UIViewController {

    @IBOutlet weak var peekImageView: UIImageView!
    
    
    var image: UIImage? {
        didSet {
            if let image = image {
                peekImageView.image = image
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
