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
        
        data["objectId"] = product.objectId
        data["name"] = product["name"] as! String
        data["imageUrl"] = (product["image"] as! PFFile).url
        data["description"] = product["descript"] as! String
        data["brand"] = product["brand"] as! String
        
        self.init(data: data)
    }
}