//
//  PhotoViewController.swift
//  Goals
//
//  Created by Isabella Teng on 7/18/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse

class PhotoViewController: UIViewController {

    private var backgroundImage: UIImage
    
    var currentUpdate: PFObject?

    init(image: UIImage, update: PFObject) {
        self.backgroundImage = image
        self.currentUpdate = update
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        let backgroundImageView = UIImageView(frame: view.frame)
        backgroundImageView.contentMode = UIViewContentMode.scaleAspectFit
        backgroundImageView.image = backgroundImage
        view.addSubview(backgroundImageView)
        
        let origImage = #imageLiteral(resourceName: "cross-filled")
        let tintedImage = origImage.withRenderingMode(.alwaysTemplate)
        let cancelButton = UIButton(frame: CGRect(x: 10.0, y: 20.0, width: 45.0, height: 45.0))
        cancelButton.imageView?.contentMode = UIViewContentMode.scaleAspectFill
        cancelButton.setImage(tintedImage, for: UIControlState())
        cancelButton.tintColor = UIColor.white
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        let editButton = UIButton(frame: CGRect(x: 0, y: view.frame.height - 65, width: view.frame.width, height: 65))
        editButton.setTitle("Add a caption", for: UIControlState())
        editButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 22)
        editButton.backgroundColor = UIColor(red: 0.60, green: 0.40, blue: 0.70, alpha: 1.0)
        editButton.addTarget(self, action: #selector(edit), for: .touchUpInside)
        view.addSubview(editButton)
    }
    
    
    func cancel() {
        dismiss(animated: false, completion: nil)
    }
    
    func edit() {
        let newVC: UIViewController = AddCaptionViewController(mediaInfo: backgroundImage, update: currentUpdate!, mediaType: "photo")
        self.present(newVC, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
