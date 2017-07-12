//
//  DetailViewController.swift
//  Goals
//
//  Created by Josh Olumese on 7/11/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

//use the same feedcell for the log

import UIKit
import Parse
import ParseUI

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var updates: [PFObject] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var updateTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Fetch all user's updates for that goal CHANGE function LATER
        Update.fetchUpdatesByUser(user: PFUser.current()!) { (loadedUpdates: [PFObject]?, error: Error?) in
            if error == nil {
                self.updates = loadedUpdates!
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription as Any)
            }
        }

        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return updates.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell", for: indexPath) as! LogCell
        
        cell.update = updates[indexPath.row]
        return cell
        
    }
    
    
    @IBAction func onUpdate(_ sender: Any) {
        
        var data: [String: Any] = [:]
        data["text"] = updateTextField.text
        Update.createUpdate(data: data)
        print("sent update")
        tableView.reloadData()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //send the new update to the feed view controller as well
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        <#code#>
//    }
    

    
}
