//
//  Goal.swift
//  Goals
//
//  Created by Gerardo Parra on 7/12/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Parse

class Goal: NSObject {
    
    // Goal types
    enum GoalType {
        case longTerm
        case shortTerm
    }
    
    
    // Goal categories
    enum GoalCategory {
        case education
        case health
        case fun
        case skill
        case finance
        case spiritual
    }
    
    
    // TODO: Goal icons
    
    
    // Post goal to Parse database
    class func createGoal(data: [String: Any]) {
        // Create Parse object PFObject
        let goal = PFObject(className: "Goal")
        
        // Add relevant fields to update object
        goal["author"] = PFUser.current()
        goal["title"] = data["title"]
        goal["description"] = data["description"]
        goal["type"] = data["type"]
        goal["categories"] = data["categories"]
//        goal["bio"] = data["bio"]
        
        // TODO: icons, progress, video replies
        goal["icon"] = NSNull()
        goal["progress"] = NSNull()
        goal["videoReplies"] = NSNull()
        
        let updateIds: [NSString] = []
        
        // TODO: Create first update
        
        goal["updates"] = updateIds
        
        // Save object (following function will save the object in Parse asynchronously)
        goal.saveInBackground()
    }
    
    
    // Fetch all goals from database
    class func fetchAllGoals(completion: @escaping ([PFObject]?, Error?) -> ()) {
        let query = PFQuery(className: "Goal")
        
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        
        query.findObjectsInBackground { (loadedGoals: [PFObject]?, error:Error?) in
            if error == nil {
                completion(loadedGoals, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    
    // Fetch all goals from a specific user
    class func fetchGoalsByUser(user: PFUser, withCompletion completion: @escaping ([PFObject]?, Error?) -> ()) {
        let query = PFQuery(className: "Goal")
        
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.whereKey("author", equalTo: user as Any)
        
        query.findObjectsInBackground { (loadedGoals: [PFObject]?, error:Error?) in
            if error == nil {
                completion(loadedGoals, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
}
