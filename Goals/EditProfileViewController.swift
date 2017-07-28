//
//  EditProfileViewController.swift
//  Goals
//
//  Created by Josh Olumese on 7/12/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var bioField: UITextField!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var imageButton: UIButton!
    
    
    var editedImage: UIImage?
    let user = PFUser.current()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate view with user data
        bioField.text = user?["bio"] as? String
        usernameLabel.text = user?["username"] as? String
        usernameField.text = user?["username"] as? String
        
        // Fetch user icon
        let iconUrl = user?["portrait"] as? PFFile
        iconUrl?.getDataInBackground { (imageData: Data?, error: Error?) in
            if error == nil {
                self.imagePreview.image = UIImage(data: imageData!)
            }
        }
        
        // Set up view controller image(s)
        imagePreview.layer.cornerRadius = 35
    }
    
    
    // Select image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        imageButton.setTitle("", for: .normal)
        imagePreview.image = editedImage
        
        // Dismiss UIImagePickerController and return to view controller
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
    
    @IBAction func didEditImage(_ sender: Any) {
        // Instantiate UIImagePickerController
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        // Prompt user to choose between Camera and Photo Library
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            vc.sourceType = .camera
            self.present(vc, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { action in
            vc.sourceType = .photoLibrary
            self.present(vc, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // Save data and exit view
    @IBAction func didTapSave(_ sender: Any) {
        // Check for attached image
        if imagePreview.image != nil {
            let resizedImage = resize(image: imagePreview.image!, newSize: CGSize(width: 500.0, height: 500.0))
            let imageURL = Update.getPFFileFromImage(image: resizedImage)
            user?["portrait"] = imageURL ?? NSNull()
        }
        
        user?["bio"] = bioField.text
        user?["username"] = usernameField.text
        if passwordField.text != "" && passwordField.text != nil{
            user?.password = passwordField.text
        }
        user?.saveInBackground()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // Exit view without saving
    @IBAction func didTapCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
