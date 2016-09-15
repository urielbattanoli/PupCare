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
        
        data["objectId"] = parseObject.objectId as AnyObject?
        data["promotionName"] = parseObject["promotionName"] as! String as AnyObject?
        data["image"] = (parseObject["image"] as! PFFile).url as AnyObject?
        data["promotionDescription"] = parseObject["promotionDescription"] as! String as AnyObject?
        data["lastPrice"] = parseObject["lastPrice"] as! Float as AnyObject?
        data["newPrice"] = parseObject["newPrice"] as! Float as AnyObject?
        data["initialDate"] = parseObject["initialDate"] as! Date as AnyObject?
        data["finalDate"] = parseObject["finalDate"] as! Date as AnyObject?
        
        self.init(data: data)
    }
}
