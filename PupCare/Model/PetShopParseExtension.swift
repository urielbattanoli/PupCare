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
        data["objectId"] = parseObject.objectId as AnyObject?
        data["name"] = parseObject["name"] as! String as AnyObject?
        data["photo"] = (parseObject["image"] as! PFFile).url as AnyObject?
        data["address"] = parseObject["address"] as! String as AnyObject?
        data["neighbourhood"] = parseObject["neighbourhood"] as! String as AnyObject?
        
        let petShopGeoPoint = parseObject["location"] as! PFGeoPoint
        let petShopLocation = CLLocation(latitude: petShopGeoPoint.latitude, longitude: petShopGeoPoint.longitude)
        data["location"] = petShopLocation
        
        
        data["rating"] = parseObject["rating"] as! Float as AnyObject?
        
        
        self.init(data: data)
    }

}
