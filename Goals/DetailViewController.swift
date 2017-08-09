//
//  DetailViewController.swift
//  Goals
//
//  Created by Josh Olumese on 7/11/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.

import UIKit
import Parse
import ParseUI
import PeekPop
import BubbleTransition
import AVKit
import AVFoundation

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, MediaCellDelegate, PeekPopPreviewingDelegate, UIViewControllerTransitioningDelegate, AVPlayerViewControllerDelegate, AVAudioPlayerDelegate {
     
     @IBOutlet weak var goalView: UIView!
     @IBOutlet weak var userIcon: UIImageView!
     @IBOutlet weak var usernameLabel: UILabel!
     @IBOutlet weak var updateLabel: UILabel!
     @IBOutlet weak var goalCellBg: UIView!
     @IBOutlet weak var goalCellEdges: UIView!
     @IBOutlet weak var goalLabel: UILabel!
     @IBOutlet weak var timestampLabel: UILabel!
     @IBOutlet weak var updateButton: UIBarButtonItem!
     @IBOutlet weak var favoriteButton: UIButton!
     @IBOutlet weak var favoriteCount: UILabel!
     
     @IBOutlet weak var tableView: UITableView!
     @IBOutlet weak var collectionView: UICollectionView!
     
     var comments: [[String: Any]] = []
     var media: [[String: Any]] = []
     var currentUpdate: PFObject?
     var goal: PFObject?
     var originalPos: CGFloat? = nil
     var author: PFUser? = nil
     var isFromTimelineGoal: Bool = false
     
     var likesArray: [PFUser]? = nil
     var liked = false
     //    var isFromTimeline: Bool = false
     
     var doneItem: UIBarButtonItem? = nil
     
     @IBOutlet weak var goalTopConstraint: NSLayoutConstraint!
     
     //for 3d touch
     var peekPop: PeekPop?
     var previewingContext: PreviewingContext?
     
     let transition = BubbleTransition()
     
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
          
          originalPos = tableView.frame.origin.y
          
          //        if isFromTimeline {
          //            let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
          //            self.view.addSubview(navBar)
          //
          //            let navItem = UINavigationItem(title: "Update");
          //            doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: nil, action: #selector(done));
          //            navItem.rightBarButtonItem = doneItem;
          //            navBar.setItems([navItem], animated: false);
          //
          //            //tableView.frame = CGRect(x: tableView.frame.origin.x, y: 60, width: tableView.frame.size.width, height: tableView.frame.size.height)
          //
          //            //navBar.isTranslucent = false
          //
          //            //tableView.contentInset = UIEdgeInsetsMake(-50, 0, 0, 0)
          //            goalTopConstraint.constant = 60
          //        }
          
          peekPop = PeekPop(viewController: self)
          _ = peekPop?.registerForPreviewingWithDelegate(self, sourceView: collectionView)
          
          
          
          if isFromTimelineGoal {
               let goalUpdateID = (goal?["updates"] as! [String])[0] 
               
               Update.fetchUpdateById(updateId: goalUpdateID, withCompletion: { (update: PFObject?, error:Error?) in
                    if error == nil {
                         self.currentUpdate = update
                    }
               })
          } else {
               let goalId = currentUpdate?["goalId"] as! String
               Goal.fetchGoalWithId(id: goalId, withCompletion: { (loadedGoal: PFObject?, error: Error?) in
                    if error == nil {
                         self.goal = loadedGoal!
                    }
               })
          }

          let dateFormat = DateFormatter()
          dateFormat.dateFormat = "M/d/yy"
          let goalDateUpdated = currentUpdate?["goalDate"] as! Date
          self.timestampLabel.text = String(dateFormat.string(from: goalDateUpdated))
     }
     
     func done() {
          self.dismiss(animated: true, completion: nil)
     }
     
     @IBAction func onClose(_ sender: Any) {
          self.dismiss(animated: true, completion: nil)
     }
     
     override func viewDidAppear(_ animated: Bool) {
          let typeString = currentUpdate?["type"] as! String
          if typeString == "positive" {
               goalView.backgroundColor = UIColor(red:0.50, green:0.85, blue:0.60, alpha:1.0)
               goalCellBg.backgroundColor = UIColor(red: 0.40, green: 0.75, blue: 0.45, alpha: 1.0)
               goalCellEdges.backgroundColor = goalCellBg.backgroundColor
          } else if typeString == "negative" {
               goalView.backgroundColor = UIColor(red:0.95, green:0.45, blue:0.45, alpha:1.0)
               goalCellBg.backgroundColor = UIColor(red: 0.85, green: 0.30, blue: 0.30, alpha: 1.0)
               goalCellEdges.backgroundColor = goalCellBg.backgroundColor
          } else if typeString == "Complete" {
               goalView.backgroundColor = UIColor(red:0.93, green:0.71, blue:0.13, alpha:1.0)
               goalCellBg.backgroundColor = UIColor(red:0.93, green:0.61, blue:0.12, alpha:1.0)
               goalCellEdges.backgroundColor = goalCellBg.backgroundColor
               
          } else {
               goalView.backgroundColor = UIColor(red: 0.45, green: 0.50, blue: 0.90, alpha: 1.0)
               goalCellBg.backgroundColor = UIColor(red: 0.35, green: 0.40, blue: 0.70, alpha: 1.0)
               goalCellEdges.backgroundColor = goalCellBg.backgroundColor
          }

          author = currentUpdate?["author"] as? PFUser
          usernameLabel.text = author?["username"] as? String
          
          if author?.objectId != PFUser.current()?.objectId || goal?["isCompleted"] as! Bool {
               updateButton.image = nil
               updateButton.isEnabled = false
          } else {
               updateButton.image = #imageLiteral(resourceName: "pencil")
               updateButton.isEnabled = true
          }
          
          updateLabel.text = currentUpdate?["text"] as? String
          goalLabel.text = currentUpdate?["goalTitle"] as? String
          
          media = currentUpdate?["activity"] as! [[String: Any]]
          collectionView.reloadData()
          
          comments = currentUpdate?["comments"] as! [[String: Any]]
          tableView.reloadData()
          //        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
          
          let indexPath = IndexPath(row: comments.count, section: 0)
          self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
          
          likesArray = currentUpdate?["likes"] as? [PFUser]
          
          let currentLikeCount = currentUpdate?["likeCount"] as! Int
          self.favoriteCount.text = String(currentLikeCount)
          
          if isLiked() {
               self.favoriteButton.isSelected = true
               liked = true
          } else {
               self.favoriteButton.isSelected = false
               liked = false
          }
          
          let iconUrl = author?["portrait"] as? PFFile
          iconUrl?.getDataInBackground { (image: Data?, error: Error?) in
               if error == nil {
                    self.userIcon.image = UIImage(data: image!)
               }
          }
          
          if let updateImage = currentUpdate?["image"] as? PFFile {
               media.append(["type": "photo", "image": updateImage, "sender": currentUpdate?["author"]!, "caption": updateLabel.text!, "rotated": true])
               collectionView.reloadData()
          }
     }
     
     
     func isLiked() -> Bool {
          for liker in likesArray! {
               if PFUser.current()?.objectId! == liker.objectId {
                    return true
               }
          }
          return false
     }
     
     func removeLike() {
          for (index, liker) in likesArray!.enumerated() {
               if PFUser.current()?.objectId == liker.objectId {
                    likesArray?.remove(at: index)
               }
          }
     }
     
     @IBAction func onFavorite(_ sender: Any) {
          if liked {
               favoriteButton.isSelected = false
               currentUpdate?.incrementKey("likeCount", byAmount: -1)
               liked = false
               removeLike()
          } else {
               favoriteButton.isSelected = true
               currentUpdate?.incrementKey("likeCount", byAmount: 1)
               liked = true
               likesArray!.append(PFUser.current()!)
          }
          
          favoriteCount.text = String(currentUpdate?["likeCount"] as! Int)
          
          currentUpdate?["likes"] = likesArray
          currentUpdate?.saveInBackground()
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
               cell.vc = self
               
               //insert comment into comment array and then reload table
               
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
          
          cell.delegate = self
          cell.data = media[indexPath.row]
          cell.onDetails = true
          cell.parent = self
          
          return cell
     }
     
     //for 3d touch preview
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          _ = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailMediaCell", for: indexPath) as! MediaCell
          let storyboard = UIStoryboard(name:"Main", bundle:nil)
          if let previewViewController = storyboard.instantiateViewController(withIdentifier: "FullMediaViewController") as? FullMediaViewController {
               self.present(previewViewController, animated: true, completion: nil)
          }
     }
     
     func previewingContext(_ previewingContext: PreviewingContext, viewControllerForLocation location: CGPoint) -> UIViewController? {
          
          let storyboard = UIStoryboard(name:"Main", bundle:nil)
          if let previewViewController = storyboard.instantiateViewController(withIdentifier: "FullMediaViewController") as? FullMediaViewController {
               if let indexPath = collectionView!.indexPathForItem(at: location) {
                    if let layoutAttributes = collectionView!.layoutAttributesForItem(at: indexPath) {
                         previewingContext.sourceRect = layoutAttributes.frame
                    }
                    previewViewController.data = media[indexPath.item]
                    previewViewController.fromForceTouch = true
               }
               return previewViewController
          }
          return nil
     }
     
     func previewingContext(_ previewingContext: PreviewingContext, commitViewController viewControllerToCommit: UIViewController) {
          self.navigationController?.pushViewController(viewControllerToCommit, animated: false)
     }
     
     func mediaCell(_ mediaCell: MediaCell, didTap data: [String: Any]) {
          print("hello")
          print(data)
          performSegue(withIdentifier: "fullMediaSegue", sender: data)
     }
     
     
     func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
          transition.transitionMode = .present
          transition.startingPoint = CGPoint(x: 175, y: 350)
          transition.duration = 0.25
          transition.bubbleColor = UIColor.white
          return transition
     }
     
     func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
          transition.transitionMode = .dismiss
          transition.startingPoint = CGPoint(x: 175, y: 350)
          transition.duration = 0.25
          transition.bubbleColor = UIColor.white
          return transition
     }
     
     override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
     }
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "updateDetailSegue" {
               let vc = segue.destination as! PostUpdateViewController
               vc.currentGoal = goal
               vc.transitioningDelegate = self
               vc.modalPresentationStyle = .custom
          } else if segue.identifier == "snapDetailSegue" {
               let vc = segue.destination as! CameraViewController
               vc.currentUpdate = currentUpdate!
          } else if segue.identifier == "fullMediaSegue" {
               let vc = segue.destination as! FullMediaViewController
               vc.data = sender as? [String : Any]
          }
     }
}
