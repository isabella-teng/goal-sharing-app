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
    
    var user: PFUser? = nil
    var fromFeed: Bool = false
    var allUserPosts: [PFObject]? = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        usernameLabel.text = PFUser.current()?.username
        
        if !fromFeed {
            self.user = PFUser.current()
            closeButton.isHidden = true
            logoutButton.isHidden = false
            editProfileButton.isHidden = false
        } else {
            logoutButton.isHidden = true
            editProfileButton.isHidden = true
            closeButton.isHidden = false
        }
        
        //hard code pictures and bios
        if user?.username == "isabella" {
            bioLabel.text = "Hi! I'm Isabella! My long-term goals are getting in shape, building better study habits, and reading more!"
            profileImageView.image = #imageLiteral(resourceName: "isabella")
        } else if user?.username == "gerardo" {
            bioLabel.text = "it me herro"
            profileImageView.image = #imageLiteral(resourceName: "gerardo")
        } else if user?.username == "josh" {
            bioLabel.text = "heyo"
            profileImageView.image = #imageLiteral(resourceName: "josh")
        }
        
        logoutButton.layer.cornerRadius = logoutButton.frame.height / 2
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
        profileImageView.layer.cornerRadius = 35
        profileImageView.clipsToBounds = true
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
