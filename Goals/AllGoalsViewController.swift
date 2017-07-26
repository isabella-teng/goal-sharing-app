//
//  AllGoalsViewController.swift
//  Goals
//
//  Created by Isabella Teng on 7/13/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class AllGoalsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GoalCellDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    var allGoals: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        tableView.backgroundColor = UIColor(red:0.70, green:1.00, blue:0.96, alpha:1.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Goal.fetchGoalsByUser(user: PFUser.current()!) { (loadedGoals: [PFObject]?, error: Error?) in
            if error == nil {
                self.allGoals = loadedGoals!
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    func goalCell(_ goalCell: GoalCell, didTap goal: PFObject) {
        performSegue(withIdentifier: "goalUpdateSegue", sender: goal)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allGoals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell", for: indexPath) as! GoalCell
        cell.goal = allGoals[indexPath.row]
        cell.delegate = self
        return cell
        
    }
    
    @IBAction func onClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goalUpdateSegue") {
            let vc = segue.destination as! PostUpdateViewController
            vc.currentGoal = sender as? PFObject
        }
    }
 

}
