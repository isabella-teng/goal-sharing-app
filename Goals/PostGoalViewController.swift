//
//  PostGoalViewController.swift
//  Goals
//
//  Created by Josh Olumese on 7/11/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse
import RSKPlaceholderTextView

class PostGoalViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var typeControl: UISegmentedControl!
    @IBOutlet weak var categoryControl: UISegmentedControl!
    @IBOutlet weak var logControl: UISegmentedControl!
    @IBOutlet weak var alertTime: UIDatePicker!
    var descriptionTextView: RSKPlaceholderTextView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postButton.layer.cornerRadius = postButton.frame.height / 2
        
        // Placeholder TextView
        self.descriptionTextView = RSKPlaceholderTextView(frame: CGRect(x: 16, y: 112, width: self.view.frame.width - 32, height: 122))
        self.descriptionTextView?.placeholder = "Briefly describe your goal"
        self.view.addSubview(self.descriptionTextView!)
        self.descriptionTextView?.font = UIFont (name: "HelveticaNeue-Light", size: 22)
        
        titleTextField.becomeFirstResponder()
    }

    @IBAction func didPostGoal(_ sender: Any) {
        if (descriptionTextView?.text.isEmpty)! || (titleTextField.text?.isEmpty)! {
            let alertController = UIAlertController(title: "Empty field", message: "Please provide a title and description for your goal", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Try again", style: .default, handler: nil )
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
            
            // Data to be posted
            var data: [String: Any] = [:]
            data["title"] = titleTextField.text
            data["description"] = descriptionTextView?.text
            
            let goalType = Goal.returnType(index: typeControl.selectedSegmentIndex)
            let goalCategory = Goal.returnCategory(index: categoryControl.selectedSegmentIndex)
            let logSettings = Goal.returnLogSettings(index: logControl.selectedSegmentIndex)
            data["type"] = goalType
            data["categories"] = goalCategory
            data["logTimePeriods"] = logSettings
            
            // Send request
            Goal.createGoal(data: data)
        }
    }
    
    @IBAction func cancelPost(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
