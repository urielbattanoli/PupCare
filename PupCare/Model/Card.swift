//
//  Card.swift
//  PupCare
//
//  Created by Uriel Battanoli on 7/25/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class Card: NSObject {

    let name: String
    let number: String
    let expirationDate: String
    
    init(data: [String : AnyObject]) {
        self.name = data["name"] as! String
        self.number = data["number"] as! String
        self.expirationDate = data["expirationDate"] as! String
    }
}
