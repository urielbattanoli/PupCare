//
//  PetShop.swift
//  PupCare
//
//  Created by Anderson Rogério da Silva Gralha on 7/1/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import CoreLocation

class PetShop: NSObject {

    var objectId: String = ""
    var name: String = ""
    var imageUrl: String = ""
    var address: Address
    var products: [Product] = []
    var ranking: Float = 0
    
    init(data: [String: AnyObject]) {
        self.objectId = data["objectId"] as! String
        self.name = data["name"] as! String
        self.imageUrl = data["photo"] as! String
        self.address = data["address"] as! Address
        self.ranking = data["rating"] as! Float
    }
}
