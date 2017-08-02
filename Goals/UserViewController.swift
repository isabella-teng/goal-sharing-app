//
//  UserViewController.swift
//  Goals
//
//  Created by Josh Olumese on 8/1/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class UserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UserSearchCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var allUsers: [PFUser] = []
    var filteredUsers: [PFUser] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200

    }
    
    override func viewDidAppear(_ animated: Bool) {
        User.fetchAllUsers { (loadedUsers: [PFObject]?, error: Error?) in
            if error == nil {
                self.allUsers = loadedUsers as! [PFUser]
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    func userSearchCell(_ userCell: UserSearchCell, didTap user: PFUser) {
        performSegue(withIdentifier: "searchToProfileSegue", sender: user)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserSearchCell", for: indexPath) as! UserSearchCell
        cell.user = allUsers[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "searchToProfileSegue") {
            let vc = segue.destination as! ProfileViewController
            vc.user = sender as? PFUser
            vc.fromFeed = true
        }
    }



}
