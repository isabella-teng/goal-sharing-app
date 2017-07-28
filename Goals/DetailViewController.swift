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
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var completionProgress: UIProgressView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var comments: [[String: Any]] = []
    var media: [[String: Any]] = []
    var currentUpdate: PFObject?
    
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
        userIcon.layer.cornerRadius = userIcon.frame.height / 2
        
        let typeString = currentUpdate?["type"] as! String
        if typeString == "positive" {
            goalView.backgroundColor = UIColor(red: 0.40, green: 0.75, blue: 0.45, alpha: 1.0)
        } else if typeString == "negative" {
            goalView.backgroundColor = UIColor(red:0.95, green:0.45, blue:0.45, alpha:1.0)
        } else {
            goalView.backgroundColor = UIColor(red: 0.45, green: 0.50, blue: 0.90, alpha: 1.0)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let author = currentUpdate?["author"] as! PFUser
        usernameLabel.text = author["username"] as? String
        
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
        
        let indexPath = IndexPath(row: comments.count, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
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
        
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
