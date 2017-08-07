//
//  TimelineViewController.swift
//  Goals
//
//  Created by Gerardo Parra on 7/11/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TimelineUpdateCellDelegate {
    
    @IBOutlet weak var updateButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var currentGoal: PFObject?
    var author: PFUser? = nil
    var goal: PFObject?
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
    
    override func viewDidAppear(_ animated: Bool) {
        author = currentGoal?["author"] as? PFUser
        if author?.objectId != PFUser.current()?.objectId {
            updateButton.isEnabled = true
        } else {
            updateButton.isEnabled = false
        }
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
            cell.delegate = self
            cell.parent = self
            return cell
        }
    }
    
  
    func timelineUpdateCell(_ updateCell: UpdateCell, didTap update: PFObject, tapped: [String: Any]?) {
        if tapped == nil {
            performSegue(withIdentifier: "timelineToDetailSegue", sender: update)
        } else {
            performSegue(withIdentifier: "timelineToFullMediaSegue", sender: tapped!)
        }
    }
    
    @IBAction func didTapUpdate(_ sender: Any) {
        performSegue(withIdentifier: "timelineToUpdateSegue", sender: currentGoal)
    }
    
    
    @IBAction func didTapClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "timelineToDetailSegue") {
            let vc = segue.destination as! DetailViewController
            vc.currentUpdate = sender as? PFObject
//            vc.isFromTimeline = true
            
            let goalId = vc.currentUpdate?["goalId"] as! String
            Goal.fetchGoalWithId(id: goalId, withCompletion: { (loadedGoal: PFObject?, error: Error?) in
                if error == nil {
                    vc.goal = loadedGoal
                }
            })
        } else if (segue.identifier == "timelineToUpdateSegue") {
            let vc = segue.destination as! PostUpdateViewController
            vc.currentGoal = sender as? PFObject
        } else if (segue.identifier == "timelineToFullMediaSegue") {
            let vc = segue.destination as! FullMediaViewController
            vc.data = sender as? [String: Any]
        }
    }
}
