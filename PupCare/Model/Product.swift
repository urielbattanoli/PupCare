//
//  Product.swift
//  PupCare
//
//  Created by Uriel Battanoli on 6/30/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class Product: NSObject{
    
    let objectId: String
    let name: String
    let imageUrl: String
    let descript: String
    let brand: String
    let price: NSNumber
    let stock: NSNumber
    
    init(data: [String : AnyObject]) {
        self.objectId = data["objectId"] as! String
        self.name = data["name"] as! String
        self.imageUrl = data["imageUrl"] as! String
        self.descript = data["description"] as! String
        self.brand = data["brand"] as! String
        self.price = data["price"] as! NSNumber
        self.stock = data["stock"] as! NSNumber
    }
}
