//
//  FeedViewController.swift
//  Goals
//
//  Created by Gerardo Parra on 7/11/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse
import ParseUI


class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FeedCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var updates: [PFObject] = []
    //var goal: PFObject? = nil
    var goals: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 180
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Update.fetchAllUpdates { (loadedUpdates: [PFObject]?, error: Error?) -> () in
            if error == nil {
                self.updates = loadedUpdates!
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription as Any)
            }
        }
        
        Goal.fetchAllGoals { (loadedGoals: [PFObject]?, error: Error?) in
            if error == nil {
                self.goals = loadedGoals!
                self.tableView.reloadData() //test this
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return updates.count
    }
    
    
//    func getGoal(updateId: String) {
//        Goal.fetchGoalWithId(id: updateId) { (loadedGoal: PFObject?, error: Error?) in
//            if error == nil {
//                self.goal = loadedGoal
//                //cell.goal = loadedGoal
//                //cell.titleLabel.text = loadedGoal?["title"] as! String
//                print(self.goal?["title"] as! String)
//                //print(loadedGoal?.objectId as! String)
//            } else {
//                print(error?.localizedDescription)
//            }
//        }
//        
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
        
        cell.delegate = self
        cell.update = updates[indexPath.row]
        
        let updateId = updates[indexPath.row]["goalId"] as! String
        let goal = goals.first(where: { $0.objectId == updateId })
        
        cell.goal = goal
        print(goal?.objectId)
        if (goal == nil) {
            print("pizza")
        }
        
    
        
//        let goal = goals.first { (matchedGoal: PFObject) -> Bool in
//            matchedGoal.objectId == updates[indexPath.row]["goalId"]
//        }
        
        
        //let goal = eventStore.sources.first(where: {$0.sourceType == .Local})
        //let goal = goals.first
        
        
//        let updateId = cell.update["goalId"] as! String
//        
//        getGoal(updateId: updateId)
        //cell.goal = goal
        //print(cell.goal["title"] as! String)
        
        //print(goal?["title"] as! String)
        
//        Goal.fetchGoalWithId(id: updateId) { (loadedGoal: PFObject?, error: Error?) in
//            if error == nil {
//                self.goal = loadedGoal
//                cell.goal = loadedGoal
//                cell.titleLabel.text = loadedGoal?["title"] as! String
//                print(loadedGoal?["title"] as! String)
//                //print(loadedGoal?.objectId as! String)
//            } else {
//                print(error?.localizedDescription)
//            }
//        }
        
        return cell
    }
    
    func feedCell(_ feedCell: FeedCell, didTap update: PFObject) {
        //segue sending over the goal id to the detail view controller
        performSegue(withIdentifier: "detailSegue", sender: update)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailSegue") {
            let vc = segue.destination as! DetailViewController
            vc.currentUpdate = sender as? PFObject
        }
    }
    
    @IBAction func backFromVC3(segue: UIStoryboardSegue) {
        print("unwind segue success")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
