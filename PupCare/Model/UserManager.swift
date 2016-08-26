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
    
    var user: User?
    
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
            
            self.user = User(parseObject: user)
            
            block(succeeded,"",self.user)
        }
    }
    
    
    func singInUser(username: String, password:String, response:(usuario: User?)->()){
        
        PFUser.logInWithUsernameInBackground(username, password: password) { (user, error) in
            if user != nil {
                self.user = User(parseObject: user!)
                response(usuario: self.user)
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
                        self.createUserByCurrentUser()
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
                        self.createUserByCurrentUser()
                        block()
                    })
                }
            })
        }
    }
    
    func createUserByCurrentUser(){
        if let pfUser = PFUser.currentUser(){
            self.user = User(parseObject: pfUser)
        }
    }
    
    func getLocationToSearch()->CLLocation? {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let locationType = defaults.objectForKey("location") as? Int{
            
            // -1 is currentLocation
            // >0 is to get in address user list
            
            if locationType == -1 {
                if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse){
                    let locationManager = CLLocationManager()
                    locationManager.desiredAccuracy = kCLLocationAccuracyBest
                    
                    locationManager.startUpdatingLocation()
                    
                    return locationManager.location!
                }
                else{
                    return nil
                }
                
            }
            else if locationType>0{
                if let user = self.user{
                    let address = user.addressList[locationType-1]
                    return address.location
                }
            }
        }
        return nil
    }
}
