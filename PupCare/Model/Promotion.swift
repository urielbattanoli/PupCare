//
//  Promotion.swift
//  PupCare
//
//  Created by Anderson Rogério da Silva Gralha on 7/7/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import Parse

class Promotion: NSObject {
    
    var objectId: String = ""
    var products: [Product] = []
    var petshop: PetShop!
    var promotionName: String = ""
    var promotionDescription: String = ""
    var lastPrice: Float = 0
    var newPrice: Float = 0
    var initialDate: NSDate = NSDate()
    var finalDate: NSDate = NSDate()
    
    init(data: [String: AnyObject]) {
        
        self.objectId = data["objectId"] as! String
        //self.products
//        self.petshop
        self.promotionName = data["promotionName"] as! String
        self.promotionDescription = data["promotionDescription"] as! String
        self.lastPrice = data["lastPrice"] as! Float
        self.newPrice = data["newPrice"] as! Float
        self.initialDate = data["initialDate"] as! NSDate
        self.finalDate = data["finalDate"] as! NSDate
        
        
    }
    
    override init() {
        
    }
}
