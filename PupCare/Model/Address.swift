//
//  User.swift
//  PupCare
//
//  Created by Uriel Battanoli on 7/13/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import CoreLocation

class Address: NSObject {
    
    let userId: String
    let name: String
    let street: String
    let number: NSNumber
    let neighbourhood: String
    let state: String
    let city: String
    let zip: String
    let additionalInfo : String
    var location : CLLocation
    
    init(data: [String : AnyObject]) {
        self.userId = data["userId"] as! String
        self.name = data["name"] as! String
        self.street = data["street"] as! String
        self.number = data["number"] as! NSNumber
        self.neighbourhood = data["neighbourhood"] as! String
        self.state = data["state"] as! String
        self.city = data["city"] as! String
        self.zip = data["zip"] as! String
        self.additionalInfo = data["additionalInfo"] as! String
        self.location = data["location"] as! CLLocation
    }
}
