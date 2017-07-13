//
//  FeedViewController.swift
//  Goals
//
//  Created by Gerardo Parra on 7/11/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse
import ParseUI


class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FeedCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    
    var updates: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 180
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Update.fetchAllUpdates { (loadedUpdates: [PFObject]?, error: Error?) -> () in
            if error == nil {
                self.updates = loadedUpdates!
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    func feedCell(_ feedCell: FeedCell, didTap update: PFObject) {
        print("reached this mf")
        //segue sending over the goal id to the detail view controller
        performSegue(withIdentifier: "detailSegue", sender: update)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return updates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
        
        cell.update = updates[indexPath.row]
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailSegue") {
            //send over goal id
            let vc = segue.destination as! DetailViewController
            vc.currentUpdate = sender as? PFObject
        }
    }

}
