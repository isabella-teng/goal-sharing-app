//
//  TimelineViewController.swift
//  Goals
//
//  Created by Gerardo Parra on 7/11/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentGoal: PFObject?
    var updates: [PFObject] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    // Return amount of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return updates.count + 1
    }
    
    // Format tableView cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            
            // Set up InfoCell with goal information
            let cell = (tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell)
            cell.data = currentGoal
            //cell.updatesMade = currentGoal?["updatesPerDay"] as! [Double]
            return cell
        } else {
            // Set up UpdateCells with update information
            let cell = (tableView.dequeueReusableCell(withIdentifier: "UpdateCell", for: indexPath) as! UpdateCell)
            cell.update = updates[indexPath.row - 1]
            return cell
        }
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
