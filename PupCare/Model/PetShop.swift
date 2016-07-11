//
//  PetShop.swift
//  PupCare
//
//  Created by Anderson Rogério da Silva Gralha on 7/1/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import Parse

class PetShop: NSObject {

    var objectId: String = ""
    var name: String = ""
    var imageUrl: String = ""
    var location = PFGeoPoint()
    var address: String = ""
    var neighbourhood: String = ""
    var distance: Float = 0
    var products: [Product] = []
    var ranking: Float = 0
    
    static let sharedInstance = PetShop()
    var allPetShops: [PetShop] = []
    
    init(data: [String: AnyObject]) {
        self.objectId = data["objectId"] as! String
        self.name = data["name"] as! String
        self.imageUrl = data["photo"] as! String
        self.location = data["location"] as! PFGeoPoint
        self.address = data["address"] as! String
        self.neighbourhood = data["neighbourhood"] as! String
//        self.distance = data["distance"] as! Float
        self.ranking = data["rating"] as! Float
    }
    
    override init () {
        
    }
    
}
