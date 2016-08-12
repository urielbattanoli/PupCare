//
//  PetShopParseExtension.swift
//  PupCare
//
//  Created by Anderson Rogério da Silva Gralha on 7/5/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import Parse

extension Address {
    
    convenience init(parseObject: PFObject) {
        var data = [String : AnyObject]()
        
        data["userId"] = parseObject.objectId
        data["name"] = parseObject["name"] as! String
        data["street"] = parseObject["street"] as! String
        data["number"] = parseObject["number"] as! NSNumber
        data["neighbourhood"] = parseObject["neighbourhood"] as! String
        data["state"] = parseObject["state"] as! String
        data["city"] = parseObject["city"] as! String
        data["zip"] = parseObject["zip"] as! String
        data["additionalInfo"] = parseObject["additionalInfo"] as! String
        data["location"] = parseObject["location"] as! PFGeoPoint        
        
        self.init(data: data)
    }
    
}
