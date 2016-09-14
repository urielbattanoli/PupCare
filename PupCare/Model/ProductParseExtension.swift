//
//  ProductParseExtension.swift
//  PupCare
//
//  Created by Uriel Battanoli on 7/4/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import Parse

extension Product{
    
    convenience init(parseObject: PFObject) {
        var data = [String : AnyObject]()
        
        //PetShop_Product
        data["price"] = parseObject["price"] as! NSNumber
        
        if let stock = parseObject["stockCount"] as? NSNumber{
            data["stock"] = stock
        }
        else if let quantity = parseObject["quantity"] as? NSNumber{
            data["stock"] = quantity
        }
        
        //Product
        let product = parseObject["productId"] as! PFObject
        
        data["objectId"] = product.objectId as AnyObject?
        data["name"] = product["name"] as! String as AnyObject?
        data["imageUrl"] = (product["image"] as! PFFile).url as AnyObject?
        data["description"] = product["descript"] as! String as AnyObject?
        data["brand"] = product["brand"] as! String as AnyObject?
        
        self.init(data: data)
    }
}
