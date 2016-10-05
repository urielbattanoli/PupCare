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
        
        
        var promotion: PFObject = parseObject
        
        if let promotionId = parseObject["promotionId"] as? PFObject{
            promotion = promotionId
            
            data["stock"] = parseObject["quantity"] as! NSNumber
        }
        else{
            data["stock"] = 0 as AnyObject?
        }
        
        data["petShop"] = PetShop(parseObject: promotion["petShopId"] as! PFObject)
        
        data["objectId"] = promotion.objectId as AnyObject?
        data["promotionName"] = promotion["promotionName"] as! String as AnyObject?
        data["image"] = (promotion["image"] as! PFFile).url as AnyObject?
        data["promotionDescription"] = promotion["promotionDescription"] as! String as AnyObject?
        data["lastPrice"] = promotion["lastPrice"] as! Float as AnyObject?
        data["newPrice"] = promotion["newPrice"] as! Float as AnyObject?
        data["initialDate"] = promotion["initialDate"] as! Date as AnyObject?
        data["finalDate"] = promotion["finalDate"] as! Date as AnyObject?
        
        self.init(data: data)
    }
}
