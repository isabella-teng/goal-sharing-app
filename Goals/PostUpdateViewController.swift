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

class PostUpdateViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var updateTextView: RSKPlaceholderTextView? = nil
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var typeControl: UISegmentedControl!
    @IBOutlet weak var newPostImage: UIImageView!
    @IBOutlet weak var imageButton: UIButton!

    var currentGoal: PFObject?
    let border = UIView(frame: CGRect(x: 70, y: 100, width: 1, height: 100))
    
    weak var delegate: DidPostUpdateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Placeholder TextView
        self.updateTextView = RSKPlaceholderTextView(frame: CGRect(x: 80, y: 80, width: self.view.frame.width - 95, height: 120))
        self.updateTextView?.placeholder = "What's your update?"
        self.view.addSubview(self.updateTextView!)
        self.updateTextView?.becomeFirstResponder()
        self.updateTextView?.font = UIFont (name: "HelveticaNeue-Light", size: 22)
        
        border.backgroundColor = UIColor.lightGray
        self.view.addSubview(border)

        postButton.layer.cornerRadius = 5
        newPostImage.layer.cornerRadius = 10
    }
    
    
    @IBAction func didTapImageButton(_ sender: Any) {
        // Instantiate UIImagePickerController
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
            action in
            vc.sourceType = .camera
            self.present(vc, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {
            action in
            vc.sourceType = .photoLibrary
            self.present(vc, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // Select image
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imageButton.isHidden = true
        border.isHidden = true
        updateTextView?.frame = CGRect(x: (updateTextView?.frame.origin.x)! + 30, y: (updateTextView?.frame.origin.y)!, width: (updateTextView?.frame.width)!, height: (updateTextView?.frame.height)!)
        newPostImage.image = resize(image: originalImage, newSize: CGSize(width: 700, height: 700))
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    
    // Resize image
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let zero: CGPoint = CGPoint(x: 0, y: 0)
        let resizeImageView = UIImageView(frame: CGRect(origin: zero, size: newSize))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
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
            self.dismiss(animated: true, completion: nil)
            
            // Data to post to Parse
            var data: [String: Any] = [:]
            data["text"] = updateTextView?.text
            data["goalId"] = currentGoal?.objectId
            data["goalTitle"] = currentGoal!["title"]
            data["goalDate"] = currentGoal?.createdAt
            if newPostImage.image != nil {
                data["image"] = Update.getPFFileFromImage(image: newPostImage.image)
            } else {
                data["image"] = NSNull()
            }
            
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
