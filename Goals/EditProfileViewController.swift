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
    
    var editedImage: UIImage?
    let user = PFUser.current()
    
    @IBOutlet weak var photoPreview: UIImageView!
    @IBOutlet weak var bioField: UITextField!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var imageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoPreview.layer.cornerRadius = 35
        
        if let profpic = user?["portrait"] as? PFFile {
            profpic.getDataInBackground { (imageData: Data?, error: Error?) in
                if error == nil {
                    let profImage = UIImage(data: imageData!)
                    self.photoPreview.image = profImage
                    self.imageButton.titleLabel?.text = ""
                }
            }
        }
        
        bioField.text = user?["bio"] as? String
        usernameLabel.text = user?["username"] as? String
    }
    
    // Select image
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        imageButton.isHidden = true
        photoPreview.image = editedImage
        
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
    
    @IBAction func didEditIcon(_ sender: Any) {
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
    
    @IBAction func didTapSave(_ sender: Any) {
        // Check for attached image
        if photoPreview.image != nil {
            // Resize image
            let newSize: CGSize = CGSize(width: 300.0, height: 100.0)
            let resizedImage = resize(image: photoPreview.image!, newSize: newSize)
            let imageURL = Update.getPFFileFromImage(image: resizedImage)
            user?["portrait"] = imageURL ?? NSNull()
        }
    
        user?["bio"] = bioField.text
        user?.saveInBackground()
        
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func didTapCancel(_ sender: Any) {
        self.dismiss(animated: true)
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
