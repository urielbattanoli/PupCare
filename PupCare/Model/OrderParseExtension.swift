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
        
        data["orderId"] = parseObject.objectId as AnyObject?
        data["petShop"] = PetShop(parseObject: parseObject["petShopId"] as! PFObject)
        data["date"] = parseObject.createdAt as AnyObject?
        data["price"] = parseObject["price"] as! NSNumber
        data["trackId"] = (parseObject["trackId"] as! PFObject).objectId as AnyObject?
        data["shipment"] = parseObject["shipment"] as! NSNumber
        data["addressId"] = Address(parseObject: parseObject["addressId"] as! PFObject)
        
        self.init(data: data)
    }
}
