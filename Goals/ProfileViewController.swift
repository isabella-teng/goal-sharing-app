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

protocol GoalCompletionDelegate: class {
    func goalComplete(goal: PFObject)
}

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ProfileCellDelegate, SwipeTableViewCellDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileIcon: PFImageView!
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var followUserButton: UIButton!
    
    @IBOutlet weak var goalSelection: UISegmentedControl!
    
    
    var user: PFUser? = nil
    var allUserPosts: [PFObject]? = []
    var fromFeed: Bool = false
    var isFollowing: Bool = false
    
    weak var delegate: GoalCompletionDelegate?
    
    var defaultOptions = SwipeTableOptions()
    var isSwipeRightEnabled = true
    //var buttonDisplayMode: ButtonDisplayMode = .titleAndImage
    var buttonStyle: ButtonStyle = .backgroundColor
    
    
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
    
    @IBAction func onSegmentedSwitch(_ sender: Any) {
        viewDidAppear(true)
    }
    
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
        if orientation == .right && allUserPosts![indexPath.row]["isCompleted"] as! Bool == false {
            let completionAction = SwipeAction(style: .default, title: "Complete Goal?") { action, indexPath in
            // handle action by updating model with completion
                self.allUserPosts![indexPath.row]["isCompleted"] = true
                self.allUserPosts![indexPath.row].saveInBackground()
                self.viewDidAppear(true)
                self.completionNotification(goal: self.allUserPosts![indexPath.row])
                self.tableView.reloadData()
            }
            completionAction.backgroundColor = UIColor.purple
            completionAction.title = "Complete Goal?"
            return [completionAction]
        } else if orientation == .left {
            //orientation is left, delete
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                
                
                //TODO: add alert controller before deleting
                let currentIndex = indexPath.row
                let deleteGoal = self.allUserPosts![currentIndex]
                self.allUserPosts!.remove(at: indexPath.row)
                print(deleteGoal)
                self.goalDeletionfromDatabase(goal: deleteGoal)
                print(self.allUserPosts as Any)
            }
            deleteAction.title = "Delete Goal?"
            
            //var confirmedDeletion: Bool = false
            
//            let alertController = UIAlertController(title: "Delete Goal?", message: "Confirm deletion?", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
//                confirmedDeletion = true
//            })
//            let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
//            alertController.addAction(okAction)
//            alertController.addAction(cancelAction)
//            self.present(alertController, animated: true)
//            
//            if confirmedDeletion {
//                return [deleteAction]
//            } else {
//                return []
//            }

            return [deleteAction]
        } else {
            return []
        }
    }
    
    func goalDeletionfromDatabase(goal: PFObject) {
        let announcement = Announcement(title: "You've deleted your goal")
        Whisper.show(shout: announcement, to: self)
        Update.deleteUpdatesByGoal(goalId: goal.objectId!)
        Goal.deleteGoalWithId(id: goal.objectId!)
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = orientation == .right ? .selection : .destructive
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
        data["text"] = "person completed a goal!!"
        data["goalId"] = goal.objectId
        data["goalTitle"] = goal["title"]
        data["goalDate"] = goal.createdAt
        
        let updateDate = Date()
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDateString = formatter.string(from: updateDate)
        let dayOfTheWeek = getDayOfWeek(currentDateString)
        
        var dateArray = goal["updatesPerDay"] as! [Int]
        if dayOfTheWeek  == 1 {
            dateArray[0] += 1
        } else if dayOfTheWeek  == 2 {
            dateArray[1] += 1
        } else if dayOfTheWeek  == 3 {
            dateArray[2] += 1
        } else if dayOfTheWeek  == 4 {
            dateArray[3] += 1
        } else if dayOfTheWeek  == 5 {
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
        self.delegate?.goalComplete(goal: goal)
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
