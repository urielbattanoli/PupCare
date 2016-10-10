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
                UserManager.sharedInstance.user = nil
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
                    
                    let resultAsDict = result as! [String:AnyObject]
                    
                    let pictureObjects = resultAsDict["picture"] as! [String:AnyObject]
                    let pictureData = pictureObjects["data"] as! [String:AnyObject]
                    let pictureUrl = pictureData["url"] as! String
                    let dataToPFFile = try? Data(contentsOf: URL(string: pictureUrl)!)
                    
                    let userPicture = PFFile(data: dataToPFFile!)
                    
                    let currentUser = PFUser.current()!
                    currentUser["name"] = resultAsDict["name"]
                    currentUser["email"] = resultAsDict["email"]
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
            AddressManager.sharedInstance.getAddressListFromUser(pfUser.objectId!) { (addresses) in
                self.user?.addressList = addresses
            }
        }
    }
    
    func getLocationToSearch()->CLLocation? {
        let defaults = UserDefaults.standard
        
        if let locationType = defaults.object(forKey: "location") as? Int {
            
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
                
            } else if locationType > 0 {
                if let user = self.user{
                    let address = user.addressList[locationType-1]
                    return address.location
                }
            } else if locationType == 0 {
                
                if let location = defaults.object(forKey: "geopoint") as? String {
                    let locationArr = location.components(separatedBy: "%")
                    let clLocation: CLLocation = CLLocation(latitude: Double(locationArr[0])!, longitude: Double(locationArr[1])!)
                    
                    return clLocation
                }
            
            }
        }
        return nil
    }
}
