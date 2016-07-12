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
//        let promotion = parseObject["Promotion"] as! PFObject
        
        data["objectId"] = parseObject.objectId
        data["promotionName"] = parseObject["promotionName"] as! String
        data["promotionDescription"] = parseObject["promotionDescription"] as! String
        data["lastPrice"] = parseObject["lastPrice"] as! Float
        data["newPrice"] = parseObject["newPrice"] as! Float
        data["initialDate"] = parseObject["initialDate"] as! String
        data["finalDate"] = parseObject["finalDate"] as! String
        
        self.init(data: data)
    }
}