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
    
    var products: [Product] = []
    var petshop: PetShop!
    var promotionName: String = ""
    var lastPrice: Float = 0
    var newPrice: Float = 0
    var initialDate: NSDate = NSDate()
    var finalDate: NSDate = NSDate()
    
    init(data: [String: AnyObject]) {
        self.lastPrice = data["lastPrice"] as! Float
        self.newPrice = data["newPrice"] as! Float
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSSSxxx"
        self.initialDate = dateFormatter.dateFromString(data["initialDate"] as! String)!
        self.finalDate = dateFormatter.dateFromString(data["finalDate"] as! String)!
        
    }
    
    override init() {
        
    }
}
