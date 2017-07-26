//
//  User.swift
//  Goals
//
//  Created by Isabella Teng on 7/11/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import Foundation
import Parse
import ParseUI

class User: NSObject {
    
    //save user keys upon creating
    
    
    class func fetchAllUsers(completion: @escaping ([PFObject]?, Error?) -> ()) {
        let query = PFUser.query()!
        query.order(byDescending: "createdAt")
        
        query.findObjectsInBackground { (loadedUsers: [PFObject]?, error:Error?) in
            if error == nil {
                completion(loadedUsers, nil)
            } else {
                completion(nil, error)
            }
        }
    }

    
    class func fetchUserById(userId: String, withCompletion completion: @escaping (PFObject?, Error?) -> ()) {
        let query = PFUser.query()!
        
        query.getObjectInBackground(withId: userId) { (user: PFObject?, error: Error?) in
            if error == nil {
                completion(user, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    

}
