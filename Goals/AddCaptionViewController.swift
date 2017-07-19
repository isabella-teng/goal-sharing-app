//
//  AddCaptionViewController.swift
//  
//
//  Created by Isabella Teng on 7/18/17.
//
//

import UIKit
import SwiftyCam

class AddCaptionViewController: UIViewController {

    //@IBOutlet weak var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.gray
        print("hi")
        
        let test = CGFloat((view.frame.width - (view.frame.width / 2 + 37.5)) + ((view.frame.width / 2) - 37.5) - 9.0)
        
        var postButton = UIButton(frame: CGRect(x: test, y: view.frame.height - 77.5, width: 18.0, height: 30.0))
        postButton.setImage(#imageLiteral(resourceName: "send"), for: UIControlState())
        postButton.addTarget(self, action: #selector(post), for: .touchUpInside)
        self.view.addSubview(postButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func post() {
        //dismiss the photo or video view controller, and the camera view controller
        //TO DO: add alert that user has sent message!
        //performSegue(withIdentifier: "backToFeedSegue", sender: nil)
        
        self.dismiss(animated: false, completion: nil)
        
    }
    
    
    
    


}
