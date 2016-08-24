//
//  PetShopParseExtension.swift
//  PupCare
//
//  Created by Anderson Rogério da Silva Gralha on 7/5/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import Parse
import CoreLocation

extension PetShop {
    
    convenience init(parseObject: PFObject) {
        var data = [String : AnyObject]()
        
        print(parseObject["name"] as! String)
        data["objectId"] = parseObject.objectId
        data["name"] = parseObject["name"] as! String
        data["photo"] = (parseObject["image"] as! PFFile).url
        data["address"] = parseObject["address"] as! String
        data["neighbourhood"] = parseObject["neighbourhood"] as! String
        
        let petShopGeoPoint = parseObject["location"] as! PFGeoPoint
        let petShopLocation = CLLocation(latitude: petShopGeoPoint.latitude, longitude: petShopGeoPoint.longitude)
        data["location"] = petShopLocation
        
        
        data["rating"] = parseObject["rating"] as! Float
        
        
        self.init(data: data)
    }

}
