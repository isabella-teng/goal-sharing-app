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

extension ExploreViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

class ExploreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UserSearchCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var allUsers: [PFUser] = []
    var filteredUsers: [PFUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        User.fetchAllUsers { (loadedUsers: [PFObject]?, error: Error?) in
            if error == nil {
                self.allUsers = loadedUsers as! [PFUser]
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredUsers = allUsers.filter({ (user: PFUser) -> Bool in
            return (user.username?.lowercased().contains(searchText.lowercased()))!
        })
        
        tableView.reloadData()
    }
    
    func userSearchCell(_ userCell: UserSearchCell, didTap user: PFUser) {
        performSegue(withIdentifier: "searchToProfileSegue", sender: user)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredUsers.count
        }
        return allUsers.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserSearchCell", for: indexPath) as! UserSearchCell
        
        if searchController.isActive && searchController.searchBar.text != "" {
            cell.user = filteredUsers[indexPath.row]
        } else {
            cell.user = allUsers[indexPath.row]
        }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    

    
}
