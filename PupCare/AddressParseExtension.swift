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
        
        data["addressId"] = parseObject.objectId
        data["name"] = parseObject["name"] as! String
        data["street"] = parseObject["street"] as! String
        data["number"] = parseObject["number"] as! NSNumber
        data["neighbourhood"] = parseObject["neighbourhood"] as! String
        data["state"] = parseObject["state"] as! String
        data["city"] = parseObject["city"] as! String
        data["zip"] = parseObject["zip"] as! String
        if let additionalInfo = parseObject["additionalInfo"] as? String{
            data["additionalInfo"] = additionalInfo
        }
        else{
           data["additionalInfo"] = ""
        }
        let geoPoint = parseObject["location"] as! PFGeoPoint
        data["location"] = CLLocation(latitude: geoPoint.latitude,longitude: geoPoint.longitude)
        
        self.init(data: data)
    }
    
}
