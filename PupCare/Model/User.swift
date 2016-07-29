//
//  User.swift
//  PupCare
//
//  Created by Uriel Battanoli on 7/13/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class User: NSObject {

    let userId: String
    let name: String
    let photoUrl: String
    var cards = [Card]()
    
    init(data: [String : AnyObject]) {
        self.userId = data["userId"] as! String
        self.name = data["name"] as! String
        self.photoUrl = data["photo"] as! String
    }
}
