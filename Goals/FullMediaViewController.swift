//
//  FullMediaViewController.swift
//  Goals
//
//  Created by Gerardo Parra on 8/1/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse

class FullMediaViewController: UIViewController {

    @IBOutlet weak var mediaView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    
    var data: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
