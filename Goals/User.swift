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
    
    class func setFollowersFollowing() {
        
        let user = PFObject(className: "User")
        
        user["followerCount"] = 0
        user["followingCount"] = 0
        user["followers"] = [] //array of user objects
        user["following"] = []
        
    }
}
