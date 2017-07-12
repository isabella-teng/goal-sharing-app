//
//  PostViewController.swift
//  Goals
//
//  Created by Josh Olumese on 7/11/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController {
    
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var typeControl: UISegmentedControl!
    @IBOutlet weak var categoryControl: UISegmentedControl!
    
    @IBAction func cancelPost(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postButton.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    // Temporary
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
