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

extension ExploreViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("scope changed")
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

class ExploreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UserSearchCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var allUsers: [PFUser] = []
    var filteredUsers: [PFUser] = []
    
    var allGoals: [PFObject] = []
    var filteredGoals: [PFObject] = []
    
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
        
        //Adding different scopes
        searchController.searchBar.scopeButtonTitles = ["Users", "Categories"]
        searchController.searchBar.delegate = self
        //searchController.searchBar.showsScopeBar = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if searchController.searchBar.selectedScopeButtonIndex == 0 {
            User.fetchAllUsers { (loadedUsers: [PFObject]?, error: Error?) in
                if error == nil {
                    self.allUsers = loadedUsers as! [PFUser]
                    self.tableView.reloadData()
                } else {
                    print(error?.localizedDescription as Any)
                }
            }
        } else if searchController.searchBar.selectedScopeButtonIndex == 1 {
            print("entered")
            Goal.fetchAllGoals(completion: { (loadedGoals: [PFObject]?, error: Error?) in
                if error == nil {
                    self.allGoals = loadedGoals!
                    self.tableView.reloadData()
                } else {
                    print(error?.localizedDescription as Any)
                }
            })
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        tableView.reloadData()
        if (searchController.searchBar.selectedScopeButtonIndex == 0) {
            filteredUsers = allUsers.filter({ (user: PFUser) -> Bool in
                return (user.username?.lowercased().contains(searchText.lowercased()))!
            })
        }
        
        
        tableView.reloadData()
    }
    
    func userSearchCell(_ userCell: UserSearchCell, didTap user: PFUser) {
        performSegue(withIdentifier: "searchToProfileSegue", sender: user)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.searchBar.selectedScopeButtonIndex == 0 {
            if searchController.isActive && searchController.searchBar.text != "" {
                return filteredUsers.count
            }
            return allUsers.count
        }
        
        return allGoals.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searchController.searchBar.selectedScopeButtonIndex == 0 {
            print("should not enter")
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserSearchCell", for: indexPath) as! UserSearchCell
            
            if searchController.isActive && searchController.searchBar.text != "" {
                cell.user = filteredUsers[indexPath.row]
            } else {
                cell.user = allUsers[indexPath.row]
            }
            cell.delegate = self
            return cell
        }
        
        print("should be entered")
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "GoalByCategoryCell", for: indexPath) as! GoalByCategoryCell
        categoryCell.goal = allGoals[indexPath.row]
        
        return categoryCell
        
        
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
