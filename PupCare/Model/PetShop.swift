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

    var name: String = ""
    var imageFile: UIImage = UIImage()
//    var price: NSNumber = 0
    var location = PFGeoPoint()
    
    static let sharedInstance = PetShop()
    
    var allPetShops: [PetShop] = []
    
    override init() {
        super.init()
    }
    
    static func getNearbyPetShops(latitude: Float, longitude: Float, withinKilometers: Float, response: (petshops: [PetShop]?, error: NSError?) -> ()) {
    
        let petShopsQuery = PFQuery(className: "PetShop")
        
        petShopsQuery.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: 10, longitude: 10), withinKilometers: 10)
        
        petShopsQuery.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            
            if results != nil {
                print(results)
                
                for result in results! {
                    
                    let pet = PetShop()
                    pet.name = result.objectForKey("name") as! String
                    
//                    pet.price = result.objectForKey("price") as! NSNumber
                    pet.location = result.objectForKey("location") as! PFGeoPoint
                    
                    PetShop.sharedInstance.allPetShops.append(pet)
                }
                
                
                response(petshops: PetShop.sharedInstance.allPetShops, error: error)
            }
//            response(petshops: nil, error: error)
        }
        
        
    }
    
    
    
    
}
