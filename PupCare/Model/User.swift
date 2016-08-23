//
//  User.swift
//  PupCare
//
//  Created by Uriel Battanoli on 7/13/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import CoreLocation

class User: NSObject {

    var userId: String?
    var name: String?
    var photoUrl: String?
    var email: String?
    var addressList: [Address] = []
    var location = CLLocation()
    
    init(data: [String : AnyObject]) {
        self.userId = data["userId"] as? String
        
        if let name = data["name"] as? String{
            self.name = name
        }
        if let photo = data["photo"] as? String{
            self.photoUrl = photo
        }
        if let email = data["email"] as? String{
            self.email = email
        }
    }
}
