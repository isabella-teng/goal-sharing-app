//
//  Update.swift
//  Goals
//
//  Created by Gerardo Parra on 7/11/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse

//    * Likes
//    * Comments
//    * Categories
//    * Progress
//


class Update: NSObject {
    
    // Post update to Parse database
    class func createUpdate(data: [String: Any]) {
        // Create Parse object PFObject
        let update = PFObject(className: "Update")
        
        // Add relevant fields to update object
        update["author"] = PFUser.current()
        update["text"] = data["text"]
        update["goalId"] = data["goalId"]
        update["likes"] = []
        update["likeCount"] = 0
        update["liked"] = false
        update["comments"] = []
        update["commentCount"] = 0

        

        // Save object (following function will save the object in Parse asynchronously)
        update.saveInBackground { (success: Bool, error: Error?) in
            if error == nil {
                Goal.fetchGoalWithId(id: data["goalId"] as! String, withCompletion: { (goal: PFObject?, error: Error?) in
                    if error == nil {
                        var updatesArray = goal?["updates"] as! [String]
                        updatesArray.append(update.objectId!)
                        goal?["updates"] = updatesArray
                        goal?.saveInBackground()
                    }
                })
            }
        }
    }
    
    
    // Fetch all updates from database
    class func fetchAllUpdates(completion: @escaping ([PFObject]?, Error?) -> ()) {
        let query = PFQuery(className: "Update")
        
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.includeKey("objectId")
        
        query.findObjectsInBackground { (loadedUpdates: [PFObject]?, error:Error?) in
            if error == nil {
                completion(loadedUpdates, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    
    // Fetch updates from specific user
    class func fetchUpdatesByUser(user: PFUser, withCompletion completion: @escaping ([PFObject]?, Error?) -> ()) {
        let query = PFQuery(className: "Update")
        
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.whereKey("author", equalTo: user as Any)
        
        query.findObjectsInBackground { (loadedUpdates: [PFObject]?, error:Error?) in
            if error == nil {
                completion(loadedUpdates, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
    //Add function that only gets the updates with given goal
    class func fetchUpdatesByGoal(goalid: String, withCompletion completion: @escaping ([PFObject]?, Error?) -> ()) {
        let query = PFQuery(className: "Update")
        
        query.order(byDescending: "createdAt")
        query.whereKey("goalId", equalTo: goalid as Any)
        
        query.findObjectsInBackground { (loadedUpdates: [PFObject]?, error: Error?) in
            if error == nil {
                completion(loadedUpdates, nil)
            } else {
                completion(nil, error)
            }
        }
        
    }

}
