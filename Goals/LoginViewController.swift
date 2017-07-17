//
//  LoginViewController.swift
//  Goals
//
//  Created by Isabella Teng on 7/11/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var usernameFirst: Bool = true
    var passwordFirst: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.delegate = self
        passwordField.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == usernameField && usernameFirst{
            usernameField.text = ""
            usernameFirst = false
            
        } else if textField == passwordField && passwordFirst {
            passwordField.text = ""
            passwordFirst = false
        }
        
    }
    
    @IBAction func onLogin(_ sender: Any) {
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        //let email = emailField.text ?? ""
        
        emptyCheck(user: username, pass: password)
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil )
            } else {
                let alertController = UIAlertController(title: "Error", message: "Incorrect username and/or password", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Try again", style: .default, handler: nil)
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
            }
        }
    }
    
    func emptyCheck(user: String, pass: String) {
        if user.isEmpty || pass.isEmpty {
            let alertController = UIAlertController(title: "Empty Field", message: "Please enter your username and/or password", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                print("User dismissed error")
            })
            
            alertController.addAction(okAction)
            present(alertController, animated: true) {
            }
            
        }
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let newUser = PFUser()
        
        newUser.password = passwordField.text
        newUser.username = usernameField.text
        //newUser.email = emailField.text
        
        emptyCheck(user: newUser.username!, pass: newUser.password!)
        
        newUser.signUpInBackground { (success: Bool, error:Error?) in
            if success {
                print("Created a user successfully")
                self.performSegue(withIdentifier: "loginSegue", sender: nil )
                
            } else {
                print(error?.localizedDescription as Any)
                
                if error?._code == 202 {
                    let alertController = UIAlertController(title: "Username is taken", message: "Please choose a different username", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        print("User dismissed error")
                    })
                    
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true) {
                    }
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
