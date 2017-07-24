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
import Alamofire
import AlamofireImage


class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ProfileCellDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: PFImageView!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var followUserButton: UIButton!
    
    var user: PFUser? = nil
    var fromFeed: Bool = false
    var allUserPosts: [PFObject]? = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        if !fromFeed {
            self.user = PFUser.current()
            closeButton.isHidden = true
            logoutButton.isHidden = false
            editProfileButton.isHidden = false
            followUserButton.isHidden = true
        } else if fromFeed && !(isOwnUser()) {
            logoutButton.isHidden = true
            editProfileButton.isHidden = true
            closeButton.isHidden = false
            followUserButton.isHidden = false
        }
        
        usernameLabel.text = user?.username
        bioLabel.text = user?["bio"] as? String
        
        if let profpic = user?["portrait"] as? PFFile {
            profpic.getDataInBackground { (imageData: Data?, error: Error?) in
                if error == nil {
                    let profImage = UIImage(data: imageData!)
                    self.profileImageView.image = profImage
                }
            }
        }
        
        //set the follow button accordingly
        let foundFollower = (PFUser.current()?["following"] as! [PFUser]).filter { $0==user! }
        if foundFollower.isEmpty {
            followUserButton.isSelected = true
        }
        
        logoutButton.layer.cornerRadius = logoutButton.frame.height / 2
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
        profileImageView.layer.cornerRadius = 35
        
        print("made it")
    }
    
    @IBAction func onFollowUser(_ sender: Any) {
        
//        var followingArray = PFUser.current()?["following"] as! [PFUser]
//        
//        if followUserButton.titleLabel?.text == "Follow User!" {
//            print("followed user")
//            followUserButton.isSelected = true
//            PFUser.current()?.incrementKey("followingCount", byAmount: 1)
//            //print(PFUser.current()?["followingCount"])
//            
//            followingArray.append(user!)
//        } else {
//            //follow the user
//            print("unfollowed user")
//            
//            PFUser.current()?.incrementKey("followingCount", byAmount: -1)
//            followingArray.filter { $0 != user! }
//            
//            followUserButton.isSelected = true
//        }
//        
//        PFUser.current()?["following"] = followingArray
//        PFUser.current()?.saveInBackground()
        
        
    }
    
    
    func isOwnUser() -> Bool {
        let feedUser = user?.objectId! //something wrong here
        let currUser = PFUser.current()?.objectId!
        
        var userBool: Bool = false
        
        if feedUser == currUser {
            userBool = true
        }
        
        return userBool
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
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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

    // Log user out
    @IBAction func didTapLogout(_ sender: Any) {
        PFUser.logOutInBackground { (error: Error?) in
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("logoutNotification"), object: nil)
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "profileToTimeline") {
            let vc = segue.destination as! TimelineViewController
            vc.currentGoal = sender as? PFObject
        }
    }
    
}
