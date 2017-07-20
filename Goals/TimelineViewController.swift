//
//  TimelineViewController.swift
//  Goals
//
//  Created by Gerardo Parra on 7/11/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentGoal: PFObject?
    var nodes: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentGoal == nil {
            print("you foofed")
        }

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        nodes = currentGoal?["activity"] as! [[String : Any]]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nodes.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell)
            
            let title = currentGoal?["title"] as! String
            cell.data = ["text": title]
            
            return cell
        } else if indexPath.row == 1 {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell)
            
            return cell
        } else {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "UpdateCell", for: indexPath) as! UpdateCell)
            
            cell.data = nodes[indexPath.row - 2]
            return cell
        }
    }

    @IBAction func didTapClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
