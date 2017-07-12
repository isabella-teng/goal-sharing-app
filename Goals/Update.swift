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
    
    class func createUpdate(title: String, withDescription description: String, withGoal goal: Int) {
        // Create Parse object PFObject
        let update = PFObject(className: "Update")
        
        // Add relevant fields to the object
        update["author"] = PFUser.current()
        update["title"] = title
        update["description"] = description
        update["goal"] = goal
        
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
}
