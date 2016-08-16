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
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit

class UserManager: NSObject {
    
    static let sharedInstance = UserManager()
    
    func singUpUser(name : String, email: String, password: String, block: (Bool,String, User?)->())  {
        
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
    
    
    func singInUser(username: String, password:String, response:(usuario: User?)->()){
        
        PFUser.logInWithUsernameInBackground(username, password: password) { (user, error) in
            if user != nil {
                let usuario = User(parseObject: user!)
                response(usuario: usuario)
            } else {
                response(usuario: nil)
            }
        }
        
    }
    
    func logOutUser(block: ()->()) {
        PFUser.logOutInBackgroundWithBlock { (error) in
            if error != nil {
                
            } else {
                block()
            }
        }
    }
    
    func singInWithFacebook(block: ()->()){
        
        let permissions = ["public_profile","email"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    UserManager.sharedInstance.saveAdditionalFacebookInformation({ 
                        block()
                    })
                } else {
                    block()
                    print("User logged in through Facebook!")
                }
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        }
    }
    
    func saveAdditionalFacebookInformation(block: ()->()){
        if FBSDKAccessToken.currentAccessToken() != nil {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, name, email, picture.type(large)"]).startWithCompletionHandler({ (connection, result, error) in
                if error != nil {
                    print("Error: \(error)")
                }
                else {
                    print(result)
                    
                    let pictureObjects = result.valueForKey("picture")
                    let pictureData = pictureObjects!.valueForKey("data")
                    let pictureUrl = pictureData!.valueForKey("url") as! String
                    let dataToPFFile = NSData(contentsOfURL: NSURL(string: pictureUrl)!)
                    
                    let userPicture = PFFile(data: dataToPFFile!)
                    
                    let currentUser = PFUser.currentUser()!
                    currentUser["name"] = result.valueForKey("name")
                    currentUser["email"] = result.valueForKey("email")
                    currentUser["image"] = userPicture
                    
                    
                    currentUser.saveInBackgroundWithBlock({ (true, error) in
                        block()
                    })
                }
            })
        }
    }
}
