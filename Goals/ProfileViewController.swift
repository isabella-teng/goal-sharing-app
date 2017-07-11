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


class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet weak var tableView: UITableView!
    
    var allUserPosts: [PFObject]? = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getPosts()
    }
    
    func getPosts() {
        let query = PFQuery(className: "Goal")
        
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.whereKey("author", equalTo: PFUser.current())
        
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.allUserPosts = posts
                self.tableView.reloadData()
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (allUserPosts?.count)!
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        let singlePost = allUserPosts?[indexPath.row]
        
        
        if let title = singlePost?["title"] as? String {
            cell.goalTitleLabel.text = title
        }
        
        //cell.goalTitle = singlePost
        
        return cell
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    


}
