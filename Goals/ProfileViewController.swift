//
//  ProfileViewController.swift
//  Goals
//
//  Created by Isabella Teng on 7/11/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ProfileCellDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileIcon: PFImageView!
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var followUserButton: UIButton!
    
    
    var user: PFUser? = nil
    var allUserPosts: [PFObject]? = []
    var fromFeed: Bool = false
    var isFollowing: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        // Hide/show buttons based on source
        if !fromFeed {
            self.user = PFUser.current()
            closeButton.isHidden = true
            logoutButton.isHidden = false
            editProfileButton.isHidden = false
            followUserButton.isHidden = true
        } else if fromFeed && (user?.objectId == PFUser.current()?.objectId) {
            logoutButton.isHidden = true
            editProfileButton.isHidden = false
            closeButton.isHidden = false
            followUserButton.isHidden = true
        } else {
            logoutButton.isHidden = true
            editProfileButton.isHidden = true
            closeButton.isHidden = false
            followUserButton.isHidden = false
            
            let current = PFUser.current()
            let following = current?["following"] as! [PFUser]
            for item in following {
                if item.objectId! == user?.objectId {
                    toggleFollow()
                }
            }
        }
        
        // Style buttons and images
        logoutButton.layer.cornerRadius = logoutButton.frame.height / 2
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
        followUserButton.layer.cornerRadius = followUserButton.frame.height / 2
        profileIcon.layer.cornerRadius = 35
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Fetch user updates
        Goal.fetchGoalsByUser(user: user!) { (loadedGoals: [PFObject]?, error: Error?) in
            if error == nil {
                self.allUserPosts = loadedGoals!
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription as Any)
            }
        }
        
        // Populate view with user data
        usernameLabel.text = user?.username
        bioLabel.text = user?["bio"] as? String
        
        // Fetch user icon
        let profpic = user?["portrait"] as? PFFile
        profpic?.getDataInBackground { (imageData: Data?, error: Error?) in
            if error == nil {
                let profImage = UIImage(data: imageData!)
                self.profileIcon.image = profImage
            }
        }
    }
    
    // Light status bar colors
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Style following button based on following status
    func toggleFollow() {
        if !isFollowing {
            isFollowing = true
            followUserButton.setTitle("Unfollow", for: .normal)
            followUserButton.backgroundColor = closeButton.backgroundColor
            followUserButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            isFollowing = false
            followUserButton.setTitle("Follow", for: .normal)
            followUserButton.backgroundColor = UIColor.white
            followUserButton.setTitleColor(closeButton.backgroundColor, for: .normal)
        }
    }
    
    
    // Modify button, database on tapping follow button
    @IBAction func onFollowUser(_ sender: Any) {
        toggleFollow()
        var followingArray = PFUser.current()?["following"] as! [PFUser]
        
        if !isFollowing {
            for (index, item) in followingArray.enumerated() {
                if item.objectId! == user?.objectId {
                    followingArray.remove(at: index)
                }
            }
        } else {
            followingArray.append(user!)
        }
        
        PFUser.current()?["following"] = followingArray
        PFUser.current()?.saveInBackground()
    }
    
    // Exit view
    @IBAction func didTapClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // Log user out
    @IBAction func didTapLogout(_ sender: Any) {
        PFUser.logOutInBackground { (error: Error?) in
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("logoutNotification"), object: nil)
    }
    
    
    // Return amount of tableView cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUserPosts!.count
    }
    
    // Format cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        
        cell.goal = allUserPosts![indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    func profileCell(_ profileCell: ProfileCell, didTap goal: PFObject) {
        performSegue(withIdentifier: "profileToTimeline", sender: goal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "profileToTimeline") {
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
    }
}
