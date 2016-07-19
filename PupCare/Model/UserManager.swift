//
//  UserManager.swift
//  PupCare
//
//  Created by Uriel Battanoli on 7/13/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

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
    
    static func singInWithFacebook(block: ()->()){
        
        let permissions = ["public_profile","email"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                } else {
                    print("User logged in through Facebook!")
                }
                block()
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        }
    }
    
    
    
}
