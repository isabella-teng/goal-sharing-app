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
import BubbleTransition

class AllGoalsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GoalCellDelegate, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    var allGoals: [PFObject] = []
    let transition = BubbleTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Goal.fetchGoalsByCompletion(user: PFUser.current()!, isCompleted: false) { (loadedGoals: [PFObject]?, error: Error?) in
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
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = CGPoint(x: 175, y: 350)
        transition.duration = 0.25
        transition.bubbleColor = UIColor.white
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = CGPoint(x: 175, y: 350)
        transition.duration = 0.25
        transition.bubbleColor = UIColor.white
        return transition
    }
    
    @IBAction func onClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goalUpdateSegue") {
            let vc = segue.destination as! PostUpdateViewController
            vc.currentGoal = sender as? PFObject
            vc.transitioningDelegate = self
            vc.modalPresentationStyle = .custom
        }
    }
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
