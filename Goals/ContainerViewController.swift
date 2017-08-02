//
//  ContainerViewController.swift
//  Goals
//
//  Created by Josh Olumese on 8/1/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    @IBOutlet weak var containerViewA: UIView!
    @IBOutlet weak var containerViewB: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func viewSwitcher(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: { 
                self.containerViewA.alpha = 1
                self.containerViewB.alpha = 0
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: { 
                self.containerViewA.alpha = 0
                self.containerViewB.alpha = 1
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
