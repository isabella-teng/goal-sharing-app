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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        let backgroundImageView = UIImageView(frame: view.frame)
        backgroundImageView.contentMode = UIViewContentMode.scaleAspectFit
        backgroundImageView.image = backgroundImage
        view.addSubview(backgroundImageView)
        
        let cancelButton = UIButton(frame: CGRect(x: 15.0, y: 15.0, width: 30.0, height: 30.0))
        cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        let test = CGFloat((view.frame.width - (view.frame.width / 2 + 37.5)) + ((view.frame.width / 2) - 37.5) - 9.0)
        let editButton = UIButton(frame: CGRect(x: test, y: view.frame.height - 77.5, width: 32.0, height: 32.0))
        editButton.setImage(#imageLiteral(resourceName: "edit"), for: UIControlState())
        editButton.addTarget(self, action: #selector(edit), for: .touchUpInside)
        view.addSubview(editButton)
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func edit() {
        let newVC: UIViewController = AddCaptionViewController(mediaInfo: backgroundImage, update: currentUpdate!, mediaType: "photo")
        self.present(newVC, animated: true, completion: nil)
    
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
