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
    
    
    var media: UIImage? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mediaView.image = media!
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
