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
    
    static let sharedInstance = PetShopManager()
    
    func getNearPetShops(_ latitude: Float, longitude: Float, withinKilometers: Float, response: @escaping (_ petshops: [PetShop]?, _ error: NSError?) -> ()) {
        PFCloud.callFunction(inBackground: "getNearPetShopList", withParameters: ["lat": latitude,"lng":longitude, "maxDistance":withinKilometers]) { (petshops, error) in
            var result: [PetShop] = []
            if let petshops = petshops as? [PFObject] {
                for petshop in petshops {
                    let object = PetShop(parseObject:petshop)
                    result.append(object)
                }
            } 
            print(result)
            response(result, error as NSError?)
        }
    }
    
    func petShopAsPfObject(_ petShop : PetShop) -> PFObject{
        let petShopAsPfObject = PFObject(className: "PetShop")
        petShopAsPfObject["objectId"] = petShop.objectId
        
        return petShopAsPfObject
    }
    
}
