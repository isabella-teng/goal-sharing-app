//
//  Post.swift
//  Goals
//
//  Created by Gerardo Parra on 7/11/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse

class Goal {
//    var id: Int
//    var title: String
//    var description: String
//    var likes: [User]
//    var likeCount: Int
//    var comments: [Comment]
//    var categories: [String]
    
//    func fetchUpdates() {
//        let query = PFQuery(className: "Update")
//        query.addDescendingOrder("createdAt")
//        query.includeKey("author")
//        query.findObjectsInBackground { (loadedUpdates: [PFObject]?, error:Error?) in
//            if error == nil {
//               return loadedUpdates!
//            } else {
//                print(error?.localizedDescription)
//            }
//        }
//    }
    
    func createGoal(title: String, description: String, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let goal = PFObject(className: "Goal")
        
        // Add relevant fields to the object
        goal["author"] = PFUser.current()
        goal["description"] = description
        goal["updates"] = []
        
        // Save object (following function will save the object in Parse asynchronously)
        goal.saveInBackground(block: completion)
    }
}
