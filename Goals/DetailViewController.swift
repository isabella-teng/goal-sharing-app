//
//  DetailViewController.swift
//  Goals
//
//  Created by Josh Olumese on 7/11/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.

import UIKit
import Parse
import ParseUI


class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var goalView: UIView!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var goalCellBg: UIView!
    @IBOutlet weak var goalCellEdges: UIView!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var updateButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var comments: [[String: Any]] = []
    var media: [[String: Any]] = []
    var currentUpdate: PFObject?
    var goal: PFObject?
    var originalPos: CGFloat? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        goalView.layer.cornerRadius = 10
        goalCellBg.layer.cornerRadius = 10
        userIcon.layer.cornerRadius = userIcon.frame.height / 2
        
        let typeString = currentUpdate?["type"] as! String
        if typeString == "positive" {
            goalView.backgroundColor = UIColor(red:0.50, green:0.85, blue:0.60, alpha:1.0)
            goalCellBg.backgroundColor = UIColor(red: 0.40, green: 0.75, blue: 0.45, alpha: 1.0)
            goalCellEdges.backgroundColor = goalCellBg.backgroundColor
        } else if typeString == "negative" {
            goalView.backgroundColor = UIColor(red:0.95, green:0.45, blue:0.45, alpha:1.0)
            goalCellBg.backgroundColor = UIColor(red: 0.85, green: 0.30, blue: 0.30, alpha: 1.0)
            goalCellEdges.backgroundColor = goalCellBg.backgroundColor
        } else {
            goalView.backgroundColor = UIColor(red: 0.45, green: 0.50, blue: 0.90, alpha: 1.0)
            goalCellBg.backgroundColor = UIColor(red: 0.35, green: 0.40, blue: 0.70, alpha: 1.0)
            goalCellEdges.backgroundColor = goalCellBg.backgroundColor
        }
        
        originalPos = tableView.frame.origin.y
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let author = currentUpdate?["author"] as! PFUser
        usernameLabel.text = author["username"] as? String
        
        if author.objectId != PFUser.current()?.objectId || goal?["isCompleted"] as! Bool == true {
            updateButton.image = nil
            updateButton.isEnabled = false
        } else {
            updateButton.image = #imageLiteral(resourceName: "pencil")
            updateButton.isEnabled = true
            
        }
        
        let iconUrl = author["portrait"] as? PFFile
        iconUrl?.getDataInBackground { (image: Data?, error: Error?) in
            if error == nil {
                self.userIcon.image = UIImage(data: image!)
            }
        }
        
        updateLabel.text = currentUpdate?["text"] as? String
        goalLabel.text = currentUpdate?["goalTitle"] as? String
        
        media = currentUpdate?["activity"] as! [[String: Any]]
        collectionView.reloadData()
        
        comments = currentUpdate?["comments"] as! [[String: Any]]
        tableView.reloadData()
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
        
        let indexPath = IndexPath(row: comments.count, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        
//        let goalId = currentUpdate?["goalId"] as! String
//        Goal.fetchGoalWithId(id: goalId) { (loadedGoal: PFObject?, error: Error?) in
//            if error == nil {
//                self.goal = loadedGoal
//            }
//        }
    }
    
    func onTimer() {
        comments = currentUpdate?["comments"] as! [[String: Any]]
        tableView.reloadData()
    }
    
    @IBAction func didTapScreen(_ sender: Any) {
        self.view.endEditing(true)
        UITableView.animate(withDuration: 0.3) {
            var frame = self.tableView.frame
            frame.origin.y = self.originalPos!
            self.tableView.frame = frame
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == comments.count { 
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCommentCell", for: indexPath) as! DetailCommentCell
            
            cell.update = currentUpdate
            cell.parent = self.tableView
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell", for: indexPath) as! LogCell
            
            cell.update = comments[indexPath.row]
            
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return media.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailMediaCell", for: indexPath) as! MediaCell
        
        cell.data = media[indexPath.row]
        cell.onDetails = true
        
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PostUpdateViewController
        vc.currentGoal = goal
    }
}
