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
import Whisper
import BubbleTransition
import NVActivityIndicatorView

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FeedCellDelegate, DidPostUpdateDelegate, UIViewControllerTransitioningDelegate, NVActivityIndicatorViewable {

    @IBOutlet weak var tableView: UITableView!
    
    var updates: [PFObject] = []
    var usersObjectArray: [PFUser] = []
    var didPostUpdate: Bool = false
    
    var completedGoal: PFObject? = nil
    
    let transition = BubbleTransition()
    @IBOutlet weak var goalMenuButton: UIBarButtonItem!
    @IBOutlet weak var barButtonView: UIView!
    
    var refreshControl: UIRefreshControl!
    var activityIndicatorView: NVActivityIndicatorView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 180
        
        //Setup refreshcontrol
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(FeedViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        activityIndicatorView = NVActivityIndicatorView(frame: refreshControl.frame)

    }
    
    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        activityIndicatorView?.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
//        if let presenting = self.presentedViewController as?  PostUpdateViewController {
//            print("entered!")
//            didPostUpdate = true
//            
//        }
        
        print(didPostUpdate)
        
        // Fetch feed based on followed users
        let usersArray = PFUser.current()?["following"] as! [PFUser]
        Update.fetchUpdatesFromUserArray(userArray: usersArray) { (loadedUpdates: [PFObject]?, error: Error?) in
            if error == nil {
                self.updates = loadedUpdates!
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription as Any)
            }
        }
        //currently a notification you see if view appears
        if didPostUpdate {
            let message = Message(title: "Great update to your goal!", backgroundColor: UIColor(red:0.89, green:0.09, blue:0.44, alpha:1))
            Whisper.show(whisper: message, to: navigationController!, action: .present)
            hide(whisperFrom: navigationController!, after: 3)
        }
    }
    
    //TODO: Fix, is not entering
    func postedUpdate(sentUpdate: Bool) {
        print("should enter")
        didPostUpdate = sentUpdate
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
    
    //Place completed goal at top of feed
//    func goalComplete(goal: PFObject) {
//        print("hallo")
//        print(goal)
//        updates.insert(goal, at: 0)
//        self.tableView.reloadData()
//    }
 
    
    // Return amount of tableView cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return updates.count
    }
    
    // Format tableView cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
        
        cell.delegate = self
        cell.update = updates[indexPath.row]
        
        return cell
    }
    
    // Control segues
    func feedCell(_ feedCell: FeedCell, didTap update: PFObject, tappedComment: Bool, tappedCamera: Bool, tappedUser: PFUser?) {
        if tappedComment {
            performSegue(withIdentifier: "commentSegue", sender: update)
        } else if tappedCamera {
            performSegue(withIdentifier: "cameraSegue", sender: update)
        } else if tappedUser != nil {
            performSegue(withIdentifier: "profileSegue", sender: tappedUser!)
        } else {
            performSegue(withIdentifier: "detailSegue", sender: update)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailSegue") {
            let vc = segue.destination as! DetailViewController
            vc.currentUpdate = sender as? PFObject
            
            let goalId = vc.currentUpdate?["goalId"] as! String
            Goal.fetchGoalWithId(id: goalId) { (loadedGoal: PFObject?, error: Error?) in
                if error == nil {
                    vc.goal = loadedGoal
                }
            }

        } else if (segue.identifier == "commentSegue") {
            let vc = segue.destination as! PostCommentViewController
            vc.currentUpdate = sender as? PFObject
            vc.transitioningDelegate = self
            vc.modalPresentationStyle = .custom
        } else if (segue.identifier == "cameraSegue") {
            let vc = segue.destination as! CameraViewController
            vc.currentUpdate = sender as? PFObject
        } else if (segue.identifier == "profileSegue") {
            let vc = segue.destination as! ProfileViewController
            vc.user = sender as? PFUser
            vc.fromFeed = true
            
            //vc.usernameLabel.text = vc.user?.username
        }
    }
    
    
    // Return user to feed after posting update
    @IBAction func backFromVC3(segue: UIStoryboardSegue) { }
    
    //Return user to feed after completing a goal
    @IBAction func goalBackfromProfile(segue: UIStoryboardSegue) {}
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
