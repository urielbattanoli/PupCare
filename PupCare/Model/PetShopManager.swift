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
    
    static func getNearPetShops(latitude: Float, longitude: Float, withinKilometers: Float, response: (petshops: [PetShop]?, error: NSError?) -> ()) {
        PFCloud.callFunctionInBackground("getNearPetShopList", withParameters: ["lat": latitude,"lng":longitude, "maxDistance":withinKilometers]) { (petshops, error) in
            var result: [PetShop] = []
            if let petshops = petshops as? [PFObject] {
                for petshop in petshops {
                    let object = PetShop(parseObject:petshop)
                    result.append(object)
                }
            } 
            print(result)
            response(petshops: result, error: error)
        }
    }
}
