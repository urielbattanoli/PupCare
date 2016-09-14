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

extension Address {
    
    convenience init(parseObject: PFObject) {
        var data = [String : AnyObject]()
        
        data["objectId"] = parseObject.objectId as AnyObject?
        data["name"] = parseObject["name"] as! String as AnyObject?
        data["street"] = parseObject["street"] as! String as AnyObject?
        data["number"] = parseObject["number"] as! NSNumber
        data["neighbourhood"] = parseObject["neighbourhood"] as! String as AnyObject?
        data["state"] = parseObject["state"] as! String as AnyObject?
        data["city"] = parseObject["city"] as! String as AnyObject?
        data["zip"] = parseObject["zip"] as! String as AnyObject?
        if let additionalInfo = parseObject["additionalInfo"] as? String{
            data["additionalInfo"] = additionalInfo as AnyObject?
        }
        else{
           data["additionalInfo"] = "" as AnyObject?
        }
        let geoPoint = parseObject["location"] as! PFGeoPoint
        data["location"] = CLLocation(latitude: geoPoint.latitude,longitude: geoPoint.longitude)
        
        self.init(data: data)
    }
    
}
