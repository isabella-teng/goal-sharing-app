//
//  PostGoalViewController.swift
//  Goals
//
//  Created by Josh Olumese on 7/11/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse

class PostGoalViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var typeControl: UISegmentedControl!
    @IBOutlet weak var categoryControl: UISegmentedControl!
    @IBOutlet weak var logControl: UISegmentedControl!
    @IBOutlet weak var alertTime: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postButton.layer.cornerRadius = postButton.frame.height / 2
        
        
        // Set up text view placeholder
        descriptionTextView.delegate = self
        descriptionTextView.text = "Describe your goal briefly"
        descriptionTextView.textColor = UIColor.lightGray
        
        postButton.isEnabled = false
        postButton.alpha = 0.7
        
        titleTextField.delegate = self
        descriptionTextView.delegate = self
        titleTextField.becomeFirstResponder()
    }
    
    
    // Temporary
    //when you create a new goal you create a new update right now
    @IBAction func didPostGoal(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
        // Data to be posted
        var data: [String: Any] = [:]
        data["title"] = titleTextField.text
        data["description"] = descriptionTextView.text
        
        let goalType = Goal.returnType(index: typeControl.selectedSegmentIndex)
        let goalCategory = Goal.returnCategory(index: categoryControl.selectedSegmentIndex)
        let logSettings = Goal.returnLogSettings(index: logControl.selectedSegmentIndex)
        data["type"] = goalType
        data["categories"] = goalCategory
        data["logTimePeriods"] = logSettings
        
        // Send request
        Goal.createGoal(data: data)
    }
    
    @IBAction func cancelPost(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Description TextView placeholder, disabled button functionality
    func textViewDidBeginEditing(_ textView: UITextView) {
        descriptionTextView.text = ""
        descriptionTextView.textColor = UIColor.black
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (titleTextField.text?.isEmpty)! {
            postButton.isEnabled = false
            postButton.alpha = 0.7
        } else {
            postButton.isEnabled = true
            postButton.alpha = 1.0
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Describe your goal briefly"
            descriptionTextView.textColor = UIColor.lightGray
            postButton.isEnabled = false
            postButton.alpha = 0.7
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (titleTextField.text?.isEmpty)! {
            postButton.isEnabled = false
            postButton.alpha = 0.7
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if descriptionTextView.text.isEmpty || (titleTextField.text?.isEmpty)! {
            postButton.isEnabled = false
            postButton.alpha = 0.7
        } else {
            postButton.isEnabled = true
            postButton.alpha = 1.0
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
