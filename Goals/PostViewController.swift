//
//  PostViewController.swift
//  Goals
//
//  Created by Josh Olumese on 7/11/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var typeControl: UISegmentedControl!
    @IBOutlet weak var categoryControl: UISegmentedControl!
    
    var textHasBeenEdited = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postButton.layer.cornerRadius = 10
        
        descriptionTextView.delegate = self
        descriptionTextView.text = "Describe your goal briefly"
        descriptionTextView.textColor = UIColor.lightGray
        titleTextField.becomeFirstResponder()
    }
   
    // Temporary
    //when you create a new goal you create a new update right now
    @IBAction func postGoal(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        var data: [String: Any] = [:]
        data["title"] = titleTextField.text
        data["description"] = descriptionTextView.text
        
        let goalType = Goal.returnType(index: typeControl.selectedSegmentIndex)
        let goalCategory = Goal.returnCategory(index: categoryControl.selectedSegmentIndex)
        
        data["type"] = goalType
        data["categories"] = goalCategory
        
        Goal.createGoal(data: data)
    }
    
    @IBAction func cancelPost(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Placeholder, disabled button functionality
    func textViewDidBeginEditing(_ textView: UITextView) {
       descriptionTextView.text = ""
        if !textHasBeenEdited {
            postButton.isEnabled = false
            postButton.alpha = 0.7
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text.isEmpty {
            textHasBeenEdited = false
            descriptionTextView.text = "Describe your goal briefly"
            descriptionTextView.textColor = UIColor.lightGray
            postButton.isEnabled = false
            postButton.alpha = 0.7
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if !textHasBeenEdited {
            descriptionTextView.text = String(descriptionTextView.text.characters.prefix(1))
            descriptionTextView.textColor = UIColor.black
            textHasBeenEdited = true
        } else {
            postButton.isEnabled = true
            postButton.alpha = 1.0
        }
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
