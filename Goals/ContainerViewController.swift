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
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    var border: UIView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.removeBorders()
        
        border = UIView(frame: CGRect(x: -8, y: 29, width: self.view.frame.width / 2, height: 8))
        border?.backgroundColor = segmentedControl.tintColor
        segmentedControl.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 29)
        segmentedControl.insertSubview(border!, at: 0)
    }
    
    @IBAction func viewSwitcher(_ sender: UISegmentedControl) {
        view.endEditing(true)
        
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: { 
                self.containerViewA.alpha = 1
                self.containerViewB.alpha = 0
            
                self.border?.frame = CGRect(x: -8, y: 29, width: self.view.frame.width / 2, height: 8)
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: { 
                self.containerViewA.alpha = 0
                self.containerViewB.alpha = 1
                
                self.border?.frame = CGRect(x: self.view.frame.width / 2 - 8, y: 29, width: self.view.frame.width / 2, height: 8)
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension UISegmentedControl {
    func removeBorders() {
        setBackgroundImage(imageWithColor(color: UIColor.clear), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: UIColor.clear), for: .selected, barMetrics: .default)
        setTitleTextAttributes([NSForegroundColorAttributeName: self.tintColor!], for: .selected)
        setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 15)!], for: .normal)
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}
