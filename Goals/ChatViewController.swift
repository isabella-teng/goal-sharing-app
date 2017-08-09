//
//  ChatViewController.swift
//  Goals
//
//  Created by Gerardo Parra on 8/8/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageContainer: UIView!
    
    var messages: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 180
        
        sendButton.layer.cornerRadius = sendButton.frame.height / 2
        
        messages = [ ["text": "hello", "source": "partner"], ["text": "hey", "source": "self"] ]
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let source = messages[indexPath.row]["source"] as! String
        if source == "self" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OwnMessage", for: indexPath) as! MessageCell
            
            cell.message = messages[indexPath.row]
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PartnerMessage", for: indexPath) as! MessageCell
            
            cell.message = messages[indexPath.row]
            
            return cell
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.25) {
            self.messageContainer.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.messageContainer.frame.height)
        }
    }

    @IBAction func didTapScreen(_ sender: Any) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
