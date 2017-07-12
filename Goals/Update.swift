//
//  Update.swift
//  Goals
//
//  Created by Gerardo Parra on 7/11/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse


class Update: NSObject {
    
    class func createUpdate(text: String, withDescription description: String, withGoal goal: Int) {
        // Create Parse object PFObject
        let update = PFObject(className: "Update")
        
        // Add relevant fields to the object
        update["author"] = PFUser.current()
        update["text"] = text
        update["description"] = description
        update["goal"] = goal
        update["goalTitle"] = text
        
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
        query.whereKey("author", equalTo: PFUser.current() as Any)
        
        query.findObjectsInBackground { (loadedUpdates: [PFObject]?, error: Error?) in
            if let error = error {
                completion(nil, error)
            } else {
                completion(loadedUpdates, nil)
            }
        }
    }
    
    //Add function that only gets the updates by user and associated with given goal
    
}
