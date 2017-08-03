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
import SwipeCellKit
import Whisper
import SAConfettiView

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ProfileCellDelegate, SwipeTableViewCellDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileIcon: PFImageView!
    @IBOutlet weak var iconBorder: UIView!
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var followUserButton: UIButton!
    
    @IBOutlet weak var myWeek: UIButton!
    @IBOutlet weak var goalSelection: UISegmentedControl!
    
    
    var user: PFUser? = nil
    var allUserPosts: [PFObject]? = []
    var fromFeed: Bool = false
    var isFollowing: Bool = false
    
    var defaultOptions = SwipeTableOptions()
    var isSwipeRightEnabled = true
    //var buttonDisplayMode: ButtonDisplayMode = .titleAndImage
    var buttonStyle: ButtonStyle = .backgroundColor
    
    var confettiView: SAConfettiView? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myWeek.isHidden = true
        
        //if new user without portrait and bio
        
        // Set up tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        closeButton.setImage(#imageLiteral(resourceName: "cross-filled").withRenderingMode(.alwaysTemplate), for: .normal)
        closeButton.tintColor = UIColor.white
        logoutButton.setImage(#imageLiteral(resourceName: "power").withRenderingMode(.alwaysTemplate), for: .normal)
        logoutButton.tintColor = UIColor.white
        editProfileButton.setImage(#imageLiteral(resourceName: "settings").withRenderingMode(.alwaysTemplate), for: .normal)
        editProfileButton.tintColor = UIColor.white
        followUserButton.setImage(#imageLiteral(resourceName: "add").withRenderingMode(.alwaysTemplate), for: .normal)
        followUserButton.tintColor = UIColor.white
        
        // Hide/show buttons based on source
        if !fromFeed {
            self.user = PFUser.current()
            closeButton.isHidden = true
            logoutButton.isHidden = false
            editProfileButton.isHidden = false
            followUserButton.isHidden = true
        } else if fromFeed && (user?.objectId == PFUser.current()?.objectId) {
            logoutButton.isHidden = true
            editProfileButton.isHidden = true
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
        followUserButton.layer.cornerRadius = 5
        profileIcon.layer.cornerRadius = 35
        iconBorder.layer.cornerRadius = (profileIcon.layer.cornerRadius / profileIcon.frame.width) * iconBorder.frame.width
        
        
        confettiView = SAConfettiView(frame: self.view.bounds)
        confettiView?.isUserInteractionEnabled = false
        self.view.addSubview(confettiView!)
        confettiView?.type = .confetti
        confettiView?.colors = [UIColor.red, UIColor.green, UIColor.blue, UIColor.yellow, UIColor.orange, UIColor.purple]
        confettiView?.intensity = 0.75
    }
    
    @IBAction func onSegmentedSwitch(_ sender: Any) {
        viewDidAppear(true)
    }
    
    //todo: fix and don't need to fetch everytime
    override func viewDidAppear(_ animated: Bool) {
        if goalSelection.selectedSegmentIndex == 0 {
            Goal.fetchGoalsByCompletion(user: user!, isCompleted: false, withCompletion: { (loadedGoals: [PFObject]?, error: Error?) in
                if error == nil {
                    self.allUserPosts = loadedGoals!
                    self.tableView.reloadData()
                } else {
                    print(error?.localizedDescription as Any)
                }
            })
        } else {
            Goal.fetchGoalsByCompletion(user: user!, isCompleted: true, withCompletion: { (loadedGoals: [PFObject]?, error: Error?) in
                if error == nil {
                    self.allUserPosts = loadedGoals!
                    self.tableView.reloadData()
                } else {
                    print(error?.localizedDescription as Any)
                }
            })
        }
        
        // Populate view with user data
        let username = user?.username!
        usernameLabel.text = username
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
            followUserButton.setImage(#imageLiteral(resourceName: "added").withRenderingMode(.alwaysTemplate), for: .normal)
            followUserButton.tintColor = self.view.tintColor
            followUserButton.backgroundColor = UIColor.white
        } else {
            isFollowing = false
            followUserButton.setImage(#imageLiteral(resourceName: "add").withRenderingMode(.alwaysTemplate), for: .normal)
            followUserButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
            followUserButton.tintColor = UIColor.white
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
        cell.otherDelegate = self
        cell.delegate = self
        
        return cell
    }
    
    //Action buttons
    //    @IBAction func moreTapped(_ sender: Any) {
    //        let controller = UIAlertController(title: "Swipe Transition Style", message: nil, preferredStyle: .actionSheet)
    //        controller.addAction(UIAlertAction(title: "Border", style: .default, handler: { _ in self.defaultOptions.transitionStyle = .border }))
    //        controller.addAction(UIAlertAction(title: "Drag", style: .default, handler: { _ in self.defaultOptions.transitionStyle = .drag }))
    //        controller.addAction(UIAlertAction(title: "Reveal", style: .default, handler: { _ in self.defaultOptions.transitionStyle = .reveal }))
    //        controller.addAction(UIAlertAction(title: "\(isSwipeRightEnabled ? "Disable" : "Enable") Swipe Right", style: .default, handler: { _ in self.isSwipeRightEnabled = !self.isSwipeRightEnabled }))
    //        //controller.addAction(UIAlertAction(title: "Button Display Mode", style: .default, handler: { _ in self.buttonDisplayModeTapped() }))
    //        controller.addAction(UIAlertAction(title: "Button Style", style: .default, handler: { _ in self.buttonStyleTapped() }))
    //        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    //        present(controller, animated: true, completion: nil)
    //    }
    //
    ////    func buttonDisplayModeTapped() {
    ////        let controller = UIAlertController(title: "Button Display Mode", message: nil, preferredStyle: .actionSheet)
    ////        controller.addAction(UIAlertAction(title: "Image + Title", style: .default, handler: { _ in self.buttonDisplayModeTapped = .titleAndImage }))
    ////        controller.addAction(UIAlertAction(title: "Image Only", style: .default, handler: { _ in self.buttonDisplayMode = .imageOnly }))
    ////        controller.addAction(UIAlertAction(title: "Title Only", style: .default, handler: { _ in self.buttonDisplayMode = .titleOnly }))
    ////        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    ////        present(controller, animated: true, completion: nil)
    ////    }
    //
    //    func buttonStyleTapped() {
    //        let controller = UIAlertController(title: "Button Style", message: nil, preferredStyle: .actionSheet)
    //        controller.addAction(UIAlertAction(title: "Background Color", style: .default, handler: { _ in
    //            self.buttonStyle = .backgroundColor
    //            self.defaultOptions.transitionStyle = .border
    //        }))
    //        controller.addAction(UIAlertAction(title: "Circular", style: .default, handler: { _ in
    //            self.buttonStyle = .circular
    //            self.defaultOptions.transitionStyle = .reveal
    //        }))
    //        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    //        present(controller, animated: true, completion: nil)
    //
    //    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if orientation == .right && allUserPosts![indexPath.row]["isCompleted"] as! Bool == false && user?.objectId == PFUser.current()?.objectId {
            let completionAction = SwipeAction(style: .default, title: "Complete Goal?") { action, indexPath in
                // Handle action by updating model with completion
                let current = self.allUserPosts![indexPath.row]
                self.completionNotification(goal: self.allUserPosts![indexPath.row])
                self.allUserPosts?.remove(at: indexPath.row)
                tableView.reloadData()
                current["isCompleted"] = true
                current.saveInBackground()
                
                PFUser.current()?.incrementKey("activeGoalCount", byAmount: -1)
                PFUser.current()?.incrementKey("completedGoalCount")
                PFUser.current()?.saveInBackground()
                
                self.confettiView?.startConfetti()
                let when = DispatchTime.now() + 5
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.confettiView?.stopConfetti()
                }
            }
            completionAction.backgroundColor = UIColor.purple
            completionAction.title = "Complete Goal?"
            return [completionAction]
        } else if orientation == .left && user?.objectId == PFUser.current()?.objectId {
            // Orientation is left, delete
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                let alertController = UIAlertController(title: "Delete goal?", message: "Confirm", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    let current = self.allUserPosts![indexPath.row]
                    self.allUserPosts!.remove(at: indexPath.row)
                    tableView.reloadData()
                    
                    if !((current["isCompleted"] as? Bool)!) {
                        PFUser.current()?.incrementKey("activeGoalCount", byAmount: -1)
                        PFUser.current()?.saveInBackground()
                    } else {
                        PFUser.current()?.incrementKey("completedGoalCount", byAmount: -1)
                        PFUser.current()?.saveInBackground()
                    }
                    
                    self.goalDeletionfromDatabase(goal: current)
                })
                let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
            }
            return [deleteAction]
        }
        return []
    }
    
    func goalDeletionfromDatabase(goal: PFObject) {
        let announcement = Announcement(title: "You've deleted your goal")
        Whisper.show(shout: announcement, to: self)
        Update.deleteUpdatesByGoal(goalId: goal.objectId!)
        Goal.deleteGoalWithId(id: goal.objectId!)
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .selection
        options.transitionStyle = .border
        
        switch buttonStyle {
        case .backgroundColor:
            options.buttonSpacing = 11
        case .circular:
            options.buttonSpacing = 4
            options.backgroundColor = #colorLiteral(red: 0.9467939734, green: 0.9468161464, blue: 0.9468042254, alpha: 1)
        }
        return options
    }
    
    func completionNotification(goal: PFObject) {
        let announcement = Announcement(title: "Congratulations on completing your goal!")
        Whisper.show(shout: announcement, to: self) { }
        //send this goal as an update back to the database, to feed view controller
        var data: [String: Any] = [:]
        let username = user?.username!
        data["text"] = (username?.capitalized)! + " accomplished this goal!"
        data["goalId"] = goal.objectId
        data["goalTitle"] = goal["title"]
        data["goalDate"] = goal.createdAt
        data["image"] = NSNull()
        
        let updateDate = Date()
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDateString = formatter.string(from: updateDate)
        let dayOfTheWeek = getDayOfWeek(currentDateString)
        
        var dateArray = goal["updatesPerDay"] as! [Int]
        if dayOfTheWeek  == 1 {
            dateArray[0] += 1
        } else if dayOfTheWeek == 2 {
            dateArray[1] += 1
        } else if dayOfTheWeek == 3 {
            dateArray[2] += 1
        } else if dayOfTheWeek == 4 {
            dateArray[3] += 1
        } else if dayOfTheWeek == 5 {
            dateArray[4] += 1
        } else if dayOfTheWeek  == 6 {
            dateArray[5] += 1
        } else if dayOfTheWeek  == 7 {
            dateArray[6] += 1
        }
        
        goal["updatesPerDay"] = dateArray
        goal.saveInBackground()
        
        data["type"] = "Complete"
        
        Update.createUpdate(data: data)
        //self.delegate?.goalComplete(goal: goal)
    }
    
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian) //Sunday is 0
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay - 1
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
    
    enum ButtonStyle {
        case backgroundColor, circular
    }
}
