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
    var address: String = ""
    var ranking: Float = 0
    
    
    static let sharedInstance = PetShop()
//
    var allPetShops: [PetShop] = []
    
    init(data: [String: AnyObject]) {
        self.name = data["name"] as! String
        self.imageFile = data["photo"] as! UIImage
        self.location = data["location"] as! PFGeoPoint
        self.address = data["address"] as! String
        self.ranking = data["ranking"] as! Float
    }
    
    override init () {
        
    }
    
    static func getNearbyPetShops(latitude: Float, longitude: Float, withinKilometers: Float, response: (petshops: [PetShop]?, error: NSError?) -> ()) {
        
        var currentLocation = PFGeoPoint(latitude: 10, longitude: 10)
        
        PFCloud.callFunctionInBackground("getPetshopList", withParameters: ["currentLocation": currentLocation]) { (petshops, error) in
            
            if let petshops = petshops as? [PFObject] {
                
                for petshop in petshops {
                    let object = PetShop(parseObject:petshop)
                    PetShop.sharedInstance.allPetShops.append(object)
                }
            }
            
//            response(petshops: PetShop.sharedInstance.allPetShops, error: error)
            
        }
    }
}








//        let petShopsQuery = PFQuery(className: "PetShop")
//
//        petShopsQuery.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: 10, longitude: 10), withinKilometers: 10)
//
//        petShopsQuery.findObjectsInBackgroundWithBlock { (results, error) -> Void in
//
//            if results != nil {
//                print(results!)
//
//                for result in results! {
//
//                    let pet = PetShop()
//                    pet.name = result.objectForKey("name") as! String
//
////                    pet.price = result.objectForKey("price") as! NSNumber
//                    pet.location = result.objectForKey("location") as! PFGeoPoint
//
//                    PetShop.sharedInstance.allPetShops.append(pet)
//                }
//
//
//                response(petshops: PetShop.sharedInstance.allPetShops, error: error)
//            }
////            response(petshops: nil, error: error)
//        }