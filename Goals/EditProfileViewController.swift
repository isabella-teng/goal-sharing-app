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
    
    @IBOutlet weak var photoPreview: UIImageView!
    
    @IBOutlet weak var bioField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if PFUser.current()?.object(forKey: "IconURL") != nil {
            let userImageFile:PFFile = PFUser.current()?.object(forKey: "IconURL") as! PFFile
            
            userImageFile.getDataInBackground(block: { (imageData: Data?, error: Error?) in
                self.photoPreview.image = UIImage(data: imageData!)
            })
        }
    }
    
    @IBAction func takePhotoButton(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available")
            vc.sourceType = .camera
        } else {
            print("Camera not available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func choosePhotoButton(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        vc.sourceType = .photoLibrary
        
        self.present(vc, animated: true, completion: nil)
    }

    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let userImage = info[UIImagePickerControllerEditedImage] as! UIImage
        editedImage = resize(image: userImage, newSize: CGSize(width: 150, height: 150))
        photoPreview.image = editedImage

        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapSave(_ sender: Any) {
        let myUser = PFUser.current()
        let imageURL = Update.getPFFileFromImage(image: editedImage)
        myUser?["IconURL"] = imageURL
        myUser?.saveInBackground()
        
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
