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
        
        let petShop = parseObject["PetShop"] as! PFObject
        
        data["name"] = petShop["name"] as! String
        //data["photo"] = petShop["photo"] as! UIImage //
        data["location"] = petShop["description"] as! PFGeoPoint
        data["address"] = petShop["address"] as! String
        data["ranking"] = petShop["ranking"] as! Float
        
        self.init(data: data)
    }

}
