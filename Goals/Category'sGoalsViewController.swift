//
//  Category'sGoalsViewController.swift
//  Goals
//
//  Created by Isabella Teng on 8/1/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class Category_sGoalsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GoalCategoryCellDelegate {
    
    var goalCategory: String = ""
    var goals: [PFObject] = []

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100

    }
    
    override func viewDidAppear(_ animated: Bool) {
        Goal.fetchGoalsByCategory(category: goalCategory) { (loadedGoals:[PFObject]?, error: Error?) in
            if error == nil {
                self.goals = loadedGoals!
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription as Any)
            }
            
        }
    }
    
    func goalCategoryCell(_ goalCategoryCell: GoalCategoryCell, didTap goal: PFObject) {
        performSegue(withIdentifier: "goalSearchtoTimelineSegue", sender: goal)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCategoryCell", for: indexPath) as! GoalCategoryCell
        cell.goal = goals[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goalSearchtoTimelineSegue") {
            let goal = sender as! PFObject
            let vc = segue.destination as! TimelineViewController
            vc.currentGoal = goal
            
            // Fetch updates before loading timeline
            Update.fetchUpdatesByGoal(goalId: goal.objectId!, withCompletion: { (updates: [PFObject]?, error: Error?) in
                if error == nil {
                    vc.updates = updates!
                } else {
                    print(error?.localizedDescription as Any)
                }
            })
        }
    }




    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
