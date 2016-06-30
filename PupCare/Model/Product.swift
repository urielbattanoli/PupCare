//
//  Product.swift
//  PupCare
//
//  Created by Uriel Battanoli on 6/30/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import Parse

class Product: PFObject, PFSubclassing{
    
    @NSManaged var name: String
    @NSManaged var imageFile: PFFile
    @NSManaged var price: NSNumber
    @NSManaged var descript: String
    @NSManaged var brand: String
    

    static func parseClassName() -> String {
        return "Product"
    }
    
    func productImage() -> UIImageView{
        let imageView = 
    }
}
