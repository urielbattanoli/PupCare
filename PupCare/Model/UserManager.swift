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
    
    func singUpUser(_ name : String, email: String, password: String, block: @escaping (Bool,String, User?)->())  {
        
        let user = PFUser()
        
        user.username = email
        user.password = password
        user.email = email
        user["name"] = name
        
        user.signUpInBackground { (succeeded, error) in
            if let error = error {
                if let errorString = error as? String {
                    block(succeeded, errorString, nil)
                }
            }
            print("objId \(user.objectId)")
            
            self.user = User(parseObject: user)
            
            block(succeeded,"",self.user)
        }
    }
    
    
    func singInUser(_ username: String, password:String, response:@escaping (_ usuario: User?)->()){
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if user != nil {
                self.user = User(parseObject: user!)
                response(self.user)
            } else {
                response(nil)
            }
        }
        
    }
    
    func logOutUser(_ block: @escaping ()->()) {
        PFUser.logOutInBackground { (error) in
            if error != nil {
                
            } else {
                block()
            }
        }
    }
    
    func singInWithFacebook(_ block: @escaping ()->()){
        
        let permissions = ["public_profile","email"]
        
        PFFacebookUtils.logInInBackground(withReadPermissions: permissions) { (user, error) in
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
    
    func saveAdditionalFacebookInformation(_ block: @escaping ()->()){
        if FBSDKAccessToken.current() != nil {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, name, email, picture.type(large)"]).start(completionHandler: { (connection, result, error) in
                if error != nil {
                    print("Error: \(error)")
                }
                else {
                    print(result)
                    
                    let pictureObjects = result.value(forKey: "picture")
                    let pictureData = pictureObjects!.value(forKey: "data")
                    let pictureUrl = pictureData!.value(forKey: "url") as! String
                    let dataToPFFile = try? Data(contentsOf: URL(string: pictureUrl)!)
                    let resultAsDict = result as! NSDictionary
                    
                    let pictureObjects = resultAsDict.value(forKey: "picture") as! NSDictionary
                    let pictureData = pictureObjects.value(forKey: "data") as! NSDictionary
                    let pictureUrl = pictureData.value(forKey: "url") as! String
                    let dataToPFFile = try? Data(contentsOf: URL(string: pictureUrl)!)
                    
                    let currentUser = PFUser.current()!
                    currentUser["name"] = result.value(forKey: "name")
                    currentUser["email"] = result.value(forKey: "email")
                    let userPicture = PFFile(data: dataToPFFile!)

                    let currentUser = PFUser.current()!
                    currentUser["name"] = resultAsDict.value(forKey: "name")
                    currentUser["email"] = resultAsDict.value(forKey: "email")
                    currentUser["image"] = userPicture
                    
                    
                    currentUser.saveInBackground(block: { (true, error) in
                        self.createUserByCurrentUser()
                        block()
                    })
                }
            })
        }
    }
    
    func createUserByCurrentUser(){
        if let pfUser = PFUser.current(){
            self.user = User(parseObject: pfUser)
        }
    }
    
    func getLocationToSearch()->CLLocation? {
        let defaults = UserDefaults.standard
        
        if let locationType = defaults.object(forKey: "location") as? Int{
            
            // -1 is currentLocation
            // >0 is to get in address user list
            
            if locationType == -1 {
                if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse){
                    let locationManager = CLLocationManager()
                    locationManager.desiredAccuracy = kCLLocationAccuracyBest
                    
                    locationManager.startUpdatingLocation()
                    
                    return CLLocation()
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
