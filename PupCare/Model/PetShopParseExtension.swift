//
//  PetShopParseExtension.swift
//  PupCare
//
//  Created by Anderson Rogério da Silva Gralha on 7/5/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import Parse

extension PetShop {
    
    convenience init(parseObject: PFObject) {
        var data = [String : AnyObject]()
        
        print(parseObject["name"] as! String)
        
        data["name"] = parseObject["name"] as! String
        data["photo"] = (parseObject["photo"] as! PFFile).url
        data["location"] = parseObject["location"] as! PFGeoPoint
        data["address"] = parseObject["address"] as! String
        data["neighbourhood"] = parseObject["neighbourhood"] as! String
        
        
        data["rating"] = parseObject["rating"] as! Float
        
        
        self.init(data: data)
    }

}
