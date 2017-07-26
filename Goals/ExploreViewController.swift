//
//  ExploreViewController.swift
//  Goals
//
//  Created by Isabella Teng on 7/26/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse
import ParseUI


class ExploreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var allUsers: [PFUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        User.fetchAllUsers { (loadedUsers: [PFObject]?, error: Error?) in
            if error == nil {
                self.allUsers = loadedUsers as! [PFUser]
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription)
            }
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsers.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserSearchCell", for: indexPath) as! UserSearchCell
        cell.user = allUsers[indexPath.row]
        return cell
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    

    
}
