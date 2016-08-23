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
    
    var addressId: String
    var name: String
    var street: String
    var number: NSNumber
    var neighbourhood: String
    var state: String
    var city: String
    var zip: String
    var additionalInfo : String
    var location : CLLocation
    
    init(data: [String : AnyObject]) {
        self.addressId = data["objectId"] as! String
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
