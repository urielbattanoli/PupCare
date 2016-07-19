//
//  UserManager.swift
//  PupCare
//
//  Created by Uriel Battanoli on 7/13/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import Parse

class UserManager: NSObject {

    static func singUpUser(name : String, email: String, password: String, block: (Bool,String, User?)->())  {
        
        let user = PFUser()
        
        user.username = email
        user.password = password
        user.email = email
        user["name"] = name
        
        user.signUpInBackgroundWithBlock { (succeeded, error) in
            if let error = error {
                if let errorString = error.userInfo["error"] as? String {
                    block(succeeded, errorString, nil)
                }
            }
            print("objId \(user.objectId)")
            let userCreated = User(parseObject: user)
            
            block(succeeded,"",userCreated)
        }
    }
    
    static func logOutUser(block: ()->()) {
        PFUser.logOutInBackgroundWithBlock { (error) in
            if error != nil {
                
            } else {
                block()
            }
        }
    }
    
    
    
}
