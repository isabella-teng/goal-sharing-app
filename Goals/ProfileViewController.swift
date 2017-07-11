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

    
    var allUserPosts: [PFObject]? = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (allUserPosts?.count)!
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        let singlePost = allUserPosts?[indexPath.row]
        
        //cell.goalTitleLabel = singlePost
        
        return cell
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    


}
