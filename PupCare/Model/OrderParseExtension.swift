//
//  OrderParseExtension.swift
//  PupCare
//
//  Created by Uriel Battanoli on 8/12/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import Parse

extension Order {

    convenience init(parseObject: PFObject) {
        var data: [String : AnyObject] = [:]
        
        data["orderId"] = parseObject.objectId
        data["petShop"] = PetShop(parseObject: parseObject["petShopId"] as! PFObject)
        data["date"] = parseObject.createdAt
        data["price"] = parseObject["price"] as! NSNumber
        data["trackId"] = (parseObject["trackId"] as! PFObject).objectId
        data["shipment"] = parseObject["shipment"] as! NSNumber
        
        self.init(data: data)
    }
}
