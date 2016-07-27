//
//  PromotionParseExtension.swift
//  PupCare
//
//  Created by Anderson Rogério da Silva Gralha on 7/7/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import Parse

extension Promotion {
    convenience init (parseObject: PFObject) {
        
        var data = [String: AnyObject]()
        
        data["petShop"] = PetShop(parseObject: parseObject["petShopId"] as! PFObject)
        
        data["objectId"] = parseObject.objectId
        data["promotionName"] = parseObject["promotionName"] as! String
        data["image"] = (parseObject["image"] as! PFFile).url
        data["promotionDescription"] = parseObject["promotionDescription"] as! String
        data["lastPrice"] = parseObject["lastPrice"] as! Float
        data["newPrice"] = parseObject["newPrice"] as! Float
        data["initialDate"] = parseObject["initialDate"] as! NSDate
        data["finalDate"] = parseObject["finalDate"] as! NSDate
        
        self.init(data: data)
    }
}