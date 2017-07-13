//
//  DetailViewController.swift
//  Goals
//
//  Created by Josh Olumese on 7/11/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.

import UIKit
import Parse
import ParseUI


class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var updates: [PFObject] = []
    var currentUpdate: PFObject?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Fetch all user's updates for that goal

        let goalid = currentUpdate?["goalId"] as! String
        
        Update.fetchUpdatesByGoal(goalid: goalid) { (loadedUpdates: [PFObject]?, error: Error?) in

            if error == nil {
                self.updates = loadedUpdates!
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription as Any)
            }
        }

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return updates.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell", for: indexPath) as! LogCell
        
        cell.update = updates[indexPath.row]
        
        return cell
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "updateSegue") {
            //send over goal id
            
            let vc = segue.destination as! PostUpdateViewController
            //vc.delegate = self
            vc.currentUpdate = currentUpdate
            //print(vc.currentUpdate?["goalId"])
        }
    }

    
}
