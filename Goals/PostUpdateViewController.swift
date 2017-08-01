//
//  PostUpdateViewController.swift
//  Goals
//
//  Created by Gerardo Parra on 7/12/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import RSKPlaceholderTextView

protocol DidPostUpdateDelegate: class {
    func postedUpdate(sentUpdate: Bool)
}

class PostUpdateViewController: UIViewController, UITextViewDelegate {

    var updateTextView: RSKPlaceholderTextView? = nil
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var typeControl: UISegmentedControl!

    var currentGoal: PFObject?
    
    weak var delegate: DidPostUpdateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Placeholder TextView
        self.updateTextView = RSKPlaceholderTextView(frame: CGRect(x: 16, y: 69, width: self.view.frame.width - 32, height: 122))
        self.updateTextView?.placeholder = "What's your update?"
        self.view.addSubview(self.updateTextView!)
        self.updateTextView?.becomeFirstResponder()
        self.updateTextView?.font = UIFont (name: "HelveticaNeue-Light", size: 22)
        
        //create calendar (where to?)

        postButton.layer.cornerRadius = postButton.frame.height / 2
    
    }

    @IBAction func didTapCancel(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true)
    }
    
    @IBAction func didPostUpdate(_ sender: Any) {
        if (updateTextView?.text.isEmpty)! {
            let alertController = UIAlertController(title: "Empty field", message: "Cannot post an empty update", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Try again", style: .default, handler: nil )
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        } else {
            self.delegate?.postedUpdate(sentUpdate: true)
            self.dismiss(animated: true, completion: { 
//                if let presenting = UIViewController() as? FeedViewController {
//                    presenting.didPostUpdate = true
//                    //presenting.didPostUpdate = self
//                }
            })
            
            
            // Data to post to Parse
            var data: [String: Any] = [:]
            data["text"] = updateTextView?.text
            data["goalId"] = currentGoal?.objectId
            data["goalTitle"] = currentGoal!["title"]
            data["goalDate"] = currentGoal?.createdAt
            
            let updateDate = Date()
            let formatter  = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let currentDateString = formatter.string(from: updateDate)
            let dayOfTheWeek = getDayOfWeek(currentDateString)
            
            var dateArray = currentGoal?["updatesPerDay"] as! [Int]
            if dayOfTheWeek  == 1 {
                dateArray[0] += 1
            } else if dayOfTheWeek  == 2 {
                dateArray[1] += 1
            } else if dayOfTheWeek  == 3 {
                dateArray[2] += 1
            } else if dayOfTheWeek  == 4 {
                dateArray[3] += 1
            } else if dayOfTheWeek  == 5 {
                dateArray[4] += 1
            } else if dayOfTheWeek  == 6 {
                dateArray[5] += 1
            } else if dayOfTheWeek  == 7 {
                dateArray[6] += 1
            }

            currentGoal?["updatesPerDay"] = dateArray
            currentGoal?.saveInBackground()
            
            let updateType = Update.returnUpdateType(index: typeControl.selectedSegmentIndex)
            data["type"] = updateType
            
            Update.createUpdate(data: data)
        }
    }
    
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian) //Sunday is 0
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay - 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
