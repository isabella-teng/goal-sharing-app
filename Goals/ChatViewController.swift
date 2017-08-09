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
        
        messageTextField.delegate = self
        
        sendButton.layer.cornerRadius = sendButton.frame.height / 2
        
        messages = [ ["date": "Aug 1", "source": "zuck", "text": "hey man glad to have gotten you as a partner!"],
                     ["date": "Aug 1", "source": "self", "text": "you too! really excited to turn my life around"],
                     ["date": "Aug 1", "source": "self", "text": "so what made you use this app?"],
                     ["date": "Aug 1", "source": "zuck", "text": "probably same as you. I always have a lot of things I wanna do but I rarely end up doing them"] ]
        
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
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
            self.messageContainer.frame = CGRect(x: 0, y: 295, width: self.view.frame.width, height: self.messageContainer.frame.height)
            self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.tableView.frame.height - 196)
        }
        
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }

    @IBAction func didTapScreen(_ sender: Any) {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.25) {
            self.messageContainer.frame = CGRect(x: 0, y: 504, width: self.view.frame.width, height: self.messageContainer.frame.height)
            self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.tableView.frame.height + 196)
        }
        
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    @IBAction func didTapSend(_ sender: Any) {
        _ = textFieldShouldReturn(messageTextField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        UIView.animate(withDuration: 0.25) {
            self.messageContainer.frame = CGRect(x: 0, y: 504, width: self.view.frame.width, height: self.messageContainer.frame.height)
        }
        self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.tableView.frame.height + 196)
        
        messages.append(["text": messageTextField.text!, "source": "self"])
        tableView.reloadData()
        messageTextField.text = ""
        
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
