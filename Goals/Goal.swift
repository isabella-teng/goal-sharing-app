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

    // Goal categories
    enum GoalCategory: Int {
        case education
        case health
        case fun
        case finance
        case spiritual
        
        var string: String {
            switch self {
            case .education: return "Education";
            case .health: return "Health";
            case .fun: return "Fun";
            case .finance: return "Money";
            case .spiritual: return "Spiritual";
            }
        }
    }
    
    class func returnCategory(index: Int) -> String {
        let category = GoalCategory(rawValue: index)!
        return category.string
    }
    
    // TODO: Goal icons
    
    // Post goal to Parse database
    class func createGoal(data: [String: Any]) {
        // Create Parse object PFObject
        let goal = PFObject(className: "Goal")
        
        // Add relevant fields to update object
        goal["author"] = PFUser.current()
        goal["title"] = data["title"] as! String
        goal["description"] = data["description"] as! String
        goal["categories"] = data["categories"] as! String
        goal["completionDate"] = data["completionDate"] as! NSDate
        goal["intendedUpdateCount"] = data["intendedUpdateCount"] as! Int
        
        // TODO: icons, progress, video replies
        goal["icon"] = NSNull()
        goal["updatesCount"] = 0 //the first one is not counted as an update
        goal["updatesPerDay"] = [Double](repeating: 0.0, count: 7)//keeps track of the updates and on what day they were created
        goal["updates"] = [] //stores the ids of the updates
        goal["isCompleted"] = false

        
        // Save object (following function will save the object in Parse asynchronously)
        goal.saveInBackground { (success: Bool, error: Error?) in
            if error == nil {
                var updateData: [String: Any] = [:]
                updateData["text"] = data["description"]
                updateData["goalId"] = goal.objectId
                updateData["goalTitle"] = goal["title"]
                updateData["type"] = "initialGoalNoType"
                updateData["goalDate"] = goal.createdAt
                
                Update.createUpdate(data: updateData)
            }
        }
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
    
    
    // Fetch goal by ID
    class func fetchGoalWithId(id: String, withCompletion completion: @escaping (PFObject?, Error?) -> ()) {

        let query = PFQuery(className: "Goal")
        
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.whereKey("objectId", equalTo: id)
        
        query.getObjectInBackground(withId: id) { (loadedGoal: PFObject?, error: Error?) in
            if error == nil {
                completion(loadedGoal, nil)
                //print(loadedGoal?.objectId as! String)
            } else {
                completion(nil, error)
            }
        }
    }
    
    //Fetch goals by category
    class func fetchGoalsByCategory(category: String, withCompletion completion: @escaping ([PFObject]?, Error?) -> ()) {
        let query = PFQuery(className: "Goal")
        
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.whereKey("categories", equalTo: category as Any)
        
        query.findObjectsInBackground { (loadedGoals: [PFObject]?, error:Error?) in
            if error == nil {
                print(loadedGoals)
                completion(loadedGoals, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    //fetch goals by completion & for current user
    class func fetchGoalsByCompletion(user: PFUser, isCompleted: Bool, withCompletion completion: @escaping ([PFObject]?, Error?) -> ()) {
        let query = PFQuery(className: "Goal")
        
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.whereKey("author", equalTo: user as Any)
        query.whereKey("isCompleted", equalTo: isCompleted as Any)
        
        query.findObjectsInBackground { (loadedGoals: [PFObject]?, error: Error?) in
            if error == nil {
                completion(loadedGoals, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    //delete goal by id
    class func deleteGoalWithId(id: String) {
        let query = PFQuery(className: "Goal")
        query.whereKey("objectId", equalTo: id as Any)
        
        query.getObjectInBackground(withId: id) { (loadedGoal: PFObject?, error: Error?) in
            if error == nil {
                loadedGoal?.deleteInBackground()
                print("deleted goal?")
            } else {
                print(error?.localizedDescription)
            }
        }
    }

    
}
