//
//  CardManager.swift
//  PupCare
//
//  Created by Uriel Battanoli on 8/3/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import Parse

class CardManager: NSObject {
    
    static let sharedInstance = CardManager()
    
    func getCardList(userId: String, block:([Card])->()){
        let params = ["userId" : userId]
        PFCloud.callFunctionInBackground("getUserCardDetails", withParameters: params) { (objects, error) in
            var cards = [Card]()
            
            if error == nil{
                if let objects = objects as? [PFObject]{
                    for object in objects{
                        cards.append(Card(parseObject: object))
                    }
                    block(cards)
                }
            }
            else{
                block(cards)
            }
        }
    }
    
    func saveNewUserCard(card: Card, block: (Bool)->()){
        let cardPFObject = CardManager.sharedInstance.cardToPFObject(card)
        
        cardPFObject.saveInBackgroundWithBlock { (success, error) in
            block(success)
        }
    }
    
    private func cardToPFObject(card: Card) -> PFObject{
        let cardPFObject = PFObject(className: "Card")
        cardPFObject["number"] = card.number
        cardPFObject["expirationDate"] = card.expirationDate
        cardPFObject["name"] = card.name
        cardPFObject["userId"] = PFUser.currentUser()?.objectId
        
        return cardPFObject
    }
}
