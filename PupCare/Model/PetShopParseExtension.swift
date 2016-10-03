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
        
        data["objectId"] = parseObject.objectId as AnyObject?
        data["name"] = parseObject["name"] as! String as AnyObject?
        data["photo"] = (parseObject["image"] as! PFFile).url as AnyObject?
        data["address"] = Address(parseObject: parseObject["addressId"] as! PFObject)
        data["rating"] = parseObject["rating"] as! Float as AnyObject?
        
        self.init(data: data)
    }
}
