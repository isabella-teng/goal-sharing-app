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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return updates.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
        
        cell.delegate = self
        cell.update = updates[indexPath.row]

        
        return cell
    }
    
    func feedCell(_ feedCell: FeedCell, didTap update: PFObject, tappedComment: Bool, tappedCamera: Bool) {
        if tappedComment {
            performSegue(withIdentifier: "commentSegue", sender: update)
        } else if tappedCamera {
            performSegue(withIdentifier: "cameraSegue", sender: update)
        } else {
            performSegue(withIdentifier: "detailSegue", sender: update) //to Detail controller
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailSegue") {
            let vc = segue.destination as! DetailViewController
            vc.currentUpdate = sender as? PFObject
        } else if (segue.identifier == "commentSegue") {
            let vc = segue.destination as! PostCommentViewController
            vc.currentUpdate = sender as? PFObject
        } else if (segue.identifier == "cameraSegue") {
            let vc = segue.destination as! CameraViewController
            vc.currentUpdate = sender as? PFObject
        }
    }
    
    @IBAction func backFromVC3(segue: UIStoryboardSegue) {
        print("unwind segue success")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
