//
//  ExploreViewController.swift
//  Goals
//
//  Created by Gerardo Parra on 7/11/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var nodes: [[String: Any?]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        nodes = [["type": "post", "text": "Go to Chick Fil A"], ["type": "update", "text": "You started your goal of eating more chicken!"], ["type": "image", "image": #imageLiteral(resourceName: "isabella")], ["type": "update", "text": "Close--went to Whataburger"], ["type": "comment", "text": "congrats on your progress!"]]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentNode = nodes[indexPath.row]
        let currentType = currentNode["type"] as! String
        if indexPath.row == 0 {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell)
            cell.data = nodes[indexPath.row]
            return cell
        } else if currentType == "update" {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "UpdateCell", for: indexPath) as! UpdateCell)
            cell.data = nodes[indexPath.row]
            return cell
        } else if currentType == "image" || currentType == "video" {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "MediaCell", for: indexPath) as! MediaCell)
            cell.data = nodes[indexPath.row]
            return cell
        } else {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "ReactionCell", for: indexPath) as! ReactionCell)
            cell.data = nodes[indexPath.row]
            return cell
        }
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
