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
        update["likes"] = []
        update["likeCount"] = 0
        update["comments"] = []
        update["commentCount"] = 0
        
        //TODO: associate goal ID
        
        // TODO: add ID, associate to goal array
        
        // Save object (following function will save the object in Parse asynchronously)
        update.saveInBackground()
    }
    
    
    // Fetch all updates from database
    class func fetchAllUpdates(completion: @escaping ([PFObject]?, Error?) -> ()) {
        let query = PFQuery(className: "Update")
        
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        
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
    
    //Add function that only gets the updates by user and associated with given goal
//    class func fetchUpdatesByUserAndGoal(user: PFUser, goalid: String, withCompletion completion: @escaping ([PFObject?], Error?) -> ()) {
//        let query = PFQuery(
//    }
}
