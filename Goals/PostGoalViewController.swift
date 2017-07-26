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
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryControl: UISegmentedControl!
    @IBOutlet weak var chooseDateTextField: UITextField!
    @IBOutlet weak var updateNumberTextField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    
    
    var datePickerView = UIDatePicker()
    var dateFormatter = DateFormatter()
    var descriptionTextView: RSKPlaceholderTextView? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create placeholder textView
        self.descriptionTextView = RSKPlaceholderTextView(frame: CGRect(x: 16, y: 106, width: self.view.frame.width - 32, height: 65))
        self.descriptionTextView?.placeholder = "Briefly describe your goal"
        self.view.addSubview(self.descriptionTextView!)
        self.descriptionTextView?.font = UIFont (name: "HelveticaNeue-Light", size: 18)
        
        // Set up datePicker
        datePickerView.datePickerMode = UIDatePickerMode.date
        chooseDateTextField.inputView = datePickerView
        datePickerView .addTarget(self, action: #selector(handleDatePicker(sender:)), for: UIControlEvents.valueChanged)
        
        // Style view button(s)
        postButton.layer.cornerRadius = 10
    }
    
    
    // Post goal to database
    @IBAction func didPostGoal(_ sender: Any) {
        if (descriptionTextView?.text.isEmpty)! || (titleTextField.text?.isEmpty)! || (chooseDateTextField.text?.isEmpty)! || (updateNumberTextField.text?.isEmpty)! {
            // Ensure all fields are filled out
            let alertController = UIAlertController(title: "Empty field", message: "Please fill out all necessary fields", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Try again", style: .default, handler: nil )
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
            
            // Create dictionary of data to be posted
            var data: [String: Any] = [:]
            data["title"] = titleTextField.text
            data["description"] = descriptionTextView?.text
            let dateFromString = dateFormatter.date(from: chooseDateTextField.text!)
            data["completionDate"] = dateFromString
            data["intendedUpdateCount"] = Int(updateNumberTextField.text!)
            
            let goalCategory = Goal.returnCategory(index: categoryControl.selectedSegmentIndex)
            data["categories"] = goalCategory
            
            // Send request
            Goal.createGoal(data: data)
        }
    }
    
    
    // Format date
    func handleDatePicker(sender: UIDatePicker) {
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        chooseDateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    // Hide keyboard if screen is tapped
    @IBAction func didTapScreen(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func cancelPost(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
