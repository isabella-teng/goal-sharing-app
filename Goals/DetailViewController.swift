//
//  DetailViewController.swift
//  Goals
//
//  Created by Josh Olumese on 7/11/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.

import UIKit
import Parse
import ParseUI


class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var updates: [PFObject] = []
    var currentUpdate: PFObject?

    @IBOutlet weak var goalTitleLabel: UILabel!
    @IBOutlet weak var goalCreationDate: UILabel!
    @IBOutlet weak var goalView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        goalTitleLabel.text = currentUpdate?["goalTitle"] as? String
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM.dd.yy"
        let goalDate = currentUpdate?["goalDate"] as! Date
        self.goalCreationDate.text = String("Created goal on " + dateFormat.string(from: goalDate))
        
        //Fetch all user's updates for that goal
        
        var goalid: String = ""
        if currentUpdate!.parseClassName == "Update" {
            goalid = currentUpdate?["goalId"] as! String
        } else if currentUpdate!.parseClassName == "Goal" {
            goalid = (currentUpdate?.objectId!)!
        }
        
        goalView.layer.cornerRadius = 15
        goalView.backgroundColor = UIColor(red:0.53, green:0.76, blue:0.96, alpha:1.0)
        
        Update.fetchUpdatesByGoal(goalid: goalid) { (loadedUpdates: [PFObject]?, error: Error?) in

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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

    
}
