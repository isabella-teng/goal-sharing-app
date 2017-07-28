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

//extension ExploreViewController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//        print("scope changed")
//        viewDidAppear(true)
//        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
//    }
//}

class ExploreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UserSearchCellDelegate, CategoryCellDelegate {
    
    @IBOutlet weak var searchType: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var allUsers: [PFUser] = []
    var filteredUsers: [PFUser] = []
    
    var allCategories: [String] = ["Education", "Health", "Fun", "Money", "Spiritual"]
    var filteredGoals: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        //Adding different scopes
//        searchController.searchBar.scopeButtonTitles = ["Users", "Categories"]
//        searchController.searchBar.delegate = self
        //searchController.searchBar.showsScopeBar = true
        
    }
    @IBAction func onSegmentedChange(_ sender: Any) {
//        if searchType.selectedSegmentIndex == 1 {
//            searchController.searchBar.isHidden = true
//        } else {
//            searchController.searchBar.isHidden = false
//        }
        tableView.reloadData()
        viewDidAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if searchType.selectedSegmentIndex == 0 {
            User.fetchAllUsers { (loadedUsers: [PFObject]?, error: Error?) in
                if error == nil {
                    self.allUsers = loadedUsers as! [PFUser]
                    self.tableView.reloadData()
                } else {
                    print(error?.localizedDescription as Any)
                }
            }

        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        if (searchType.selectedSegmentIndex == 0) {
            filteredUsers = allUsers.filter({ (user: PFUser) -> Bool in
                return (user.username?.lowercased().contains(searchText.lowercased()))!
            })
            tableView.reloadData()
        }
        tableView.reloadData()
    }
    
    func userSearchCell(_ userCell: UserSearchCell, didTap user: PFUser) {
        performSegue(withIdentifier: "searchToProfileSegue", sender: user)
    }
    
    func categoryCell(_ categoryCell: CategoryCell, didTap categoryName: String) {
        performSegue(withIdentifier: "categorytoGoalsSegue", sender: categoryName)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchType.selectedSegmentIndex == 0 {
            if searchController.isActive && searchController.searchBar.text != "" {
                return filteredUsers.count
            }
            return allUsers.count
        }
        
        return allCategories.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searchType.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserSearchCell", for: indexPath) as! UserSearchCell
            
            if searchController.isActive && searchController.searchBar.text != "" {
                cell.user = filteredUsers[indexPath.row]
            } else {
                cell.user = allUsers[indexPath.row]
            }
            cell.delegate = self
            return cell
        } //else {

        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
//            if searchController.isActive && searchController.searchBar.text != "" {
//                //categoryCell.goal = filteredGoals[indexPath.row]
//            }
        categoryCell.delegate = self
        categoryCell.categoryLabel.text = allCategories[indexPath.row]
        
        return categoryCell 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "searchToProfileSegue") {
            let vc = segue.destination as! ProfileViewController
            vc.user = sender as? PFUser
            vc.fromFeed = true
        } else if (segue.identifier == "categorytoGoalsSegue") {
            let vc = segue.destination as! GoalsOfCategoryViewController
            vc.goalCategory = sender as! String
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
}
