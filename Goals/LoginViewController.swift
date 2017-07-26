//
//  LoginViewController.swift
//  Goals
//
//  Created by Isabella Teng on 7/11/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 5
    }
    
    // Alerts to handle errors
    func createAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message.capitalized, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    @IBAction func onLogIn(_ sender: Any) {
        // Log in and segue to home feed
        PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!) { (user: PFUser?, error: Error?) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                self.createAlert(message: (error?.localizedDescription)!)
            }
        }
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        // Create Parse user
        let newUser = PFUser()
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        newUser["following"] = []
        
        // Post user to database
        newUser.signUpInBackground { (success: Bool, error:Error?) in
            if success {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                
                // User must follow self to see own posts in feed
                let user = PFUser.current()
                user?["following"] = [PFUser.current()!]
                user?.saveInBackground()
            } else {
                self.createAlert(message: (error?.localizedDescription)!)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
