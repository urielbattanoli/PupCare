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
        data["stock"] = parseObject["stock"] as! NSNumber
        
        //Product
        let product = parseObject["product"] as! PFObject
        
        data["name"] = product["name"] as! String
        data["imageUrl"] = (product["photo"] as! PFFile).url
        data["description"] = product["description"] as! String
        data["brand"] = product["brand"] as! String
        
        self.init(data: data)
    }
}