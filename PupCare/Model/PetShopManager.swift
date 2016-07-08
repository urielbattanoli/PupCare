//
//  PetShopManager.swift
//  PupCare
//
//  Created by Anderson Rogério da Silva Gralha on 7/7/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import Parse

class PetShopManager: NSObject {
    static func getNearbyPetShops(latitude: Float, longitude: Float, withinKilometers: Float, response: (petshops: [PetShop]?, error: NSError?) -> ()) {
        
        let currentLocation = PFGeoPoint(latitude: 10, longitude: 10)
        
        PFCloud.callFunctionInBackground("getPetshopList", withParameters: ["currentLocation": currentLocation]) { (petshops, error) in
            var result: [PetShop] = []
            if let petshops = petshops as? [PFObject] {
                
                for petshop in petshops {
                    let object = PetShop(parseObject:petshop)
                    result.append(object)
                }
            }
            response(petshops: result, error: error)
        }
    }
}
