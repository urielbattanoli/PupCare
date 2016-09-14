//
//  Promotion.swift
//  PupCare
//
//  Created by Anderson Rogério da Silva Gralha on 7/7/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class Promotion: NSObject {
    
    var objectId: String = ""
    var products: [Product] = []
    var petshop: PetShop!
    var promotionName: String = ""
    var promotionImage: String = ""
    var promotionDescription: String = ""
    var lastPrice: Float = 0
    var newPrice: Float = 0
    var initialDate: Date = Date()
    var finalDate: Date = Date()
    var photos: [String] = []
    
    init(data: [String: AnyObject]) {
        
        self.objectId = data["objectId"] as! String
        self.promotionImage = data["image"] as! String
        self.petshop = data["petShop"] as! PetShop
        self.promotionName = data["promotionName"] as! String
        self.promotionDescription = data["promotionDescription"] as! String
        self.lastPrice = data["lastPrice"] as! Float
        self.newPrice = data["newPrice"] as! Float
        self.initialDate = data["initialDate"] as! Date
        self.finalDate = data["finalDate"] as! Date
        
    }
    
    override init() {
        
    }
}
