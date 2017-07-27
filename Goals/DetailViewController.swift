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
    
    @IBOutlet weak var completionProgress: UIProgressView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //percent on days left
//        var goal: PFObject?
//        
//        let calendar = NSCalendar.current
//        
//        let completionDate = currentUpdate?["goalDate"] as! Date
//        print(completionDate)
//        let currentDay = Date()
//        let updateCreation = currentUpdate?.createdAt as! Date
//        print(currentDay)
//        
//        let date1 = calendar.startOfDay(for: completionDate)
//        let date2 = calendar.startOfDay(for: currentDay)
//        let date3 = calendar.startOfDay(for: updateCreation)
//        
//        let components1 = calendar.dateComponents([.day], from: date2, to: date1) //from goal creation to current date
//        print(components1)
//        let components2 = calendar.dateComponents([.day], from: <#T##Date#>)
        
        

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
        
        Update.fetchUpdatesByGoal(goalId: goalid) { (loadedUpdates: [PFObject]?, error: Error?) in

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
