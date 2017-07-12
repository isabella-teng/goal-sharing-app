//
//  Update.swift
//  Goals
//
//  Created by Gerardo Parra on 7/11/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse

//* Name
//    * Description
//    * Timestamp
//    * User
//    * Long-term/short-term/daily
//    * Likes
//    * Comments
//    * Categories
//    * Progress
//    * Video replies
//        * Updates
//        * Likes
//        * Comments
//        * Timestamp
//


class Update: NSObject {
    
    class func createUpdate(data: [String: Any]) {
        // Create Parse object PFObject
        let update = PFObject(className: "Update")
        
        // Add relevant fields to the object
        update["author"] = PFUser.current()
        update["text"] = data["text"]
        update["description"] = data["description"]
        update["goalId"] = data["goal"]
        update["goalTitle"] = data["goalText"]
        
        // Save object (following function will save the object in Parse asynchronously)
        update.saveInBackground()
    }
    
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
    
    class func fetchUpdatesByUser(user: PFUser, withCompletion completion: @escaping ([PFObject]?, Error?) -> ()) {
        let query = PFQuery(className: "Update")
        
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.whereKey("author", equalTo: user as Any)
        
        query.findObjectsInBackground { (loadedUpdates: [PFObject]?, error: Error?) in
            if let error = error {
                completion(nil, error)
            } else {
                completion(loadedUpdates, nil)
            }
        }
    }
    
}
