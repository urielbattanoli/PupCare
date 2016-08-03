//
//  InitialViewController.swift
//  PupCare
//
//  Created by Uriel Battanoli on 6/20/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import CoreLocation
import Parse

class InitialViewController: UIViewController {
    
    let cardInfo : [String:AnyObject] = ["CardNumber": "4012001038166662",
                                         "CVV": "456",
                                         "ExpirationYear": 2017,
                                         "ExpirationMonth": 04,
                                         "CardBrand": 01,
                                         "CardHolderName": "Rebecca Sommers",
                                         "CardHolderDocumentId": "24676662718",
                                         "CardHolderBirthday": "1990-01-01"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(OrderManager.sharedInstance)
//        OrderManager.sharedInstance.getAvailableCardBrands()
//        OrderManager.sharedInstance.chechIfCardIsValid(cardInfo["CardNumber"] as! String)
//        OrderManager.sharedInstance.startTransaction(10.0, cardInfo: cardInfo)
        OrderManager.sharedInstance.getTransactionByTrackId("5iBn8nYVOv")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        //        var data = [String : AnyObject]()
        //
        //        data["userId"] = ""
        //        data["name"] = ""
        //        data["street"] = ""
        //        data["number"] = 0
        //        data["neighbourhood"] = ""
        //        data["state"] = ""
        //        data["city"] = ""
        //        data["zip"] = "90160092"
        //        data["location"] = PFGeoPoint()
        
        //        let address = Address(data: data)
        //
        //        AddressManager.sharedInstance.transformAddressToGeoPoint(address) { (geoPoint) in
        //            print(geoPoint)
        //        }
        //
        //        let location = CLLocation(latitude: -30.0674556474693, longitude: -51.2083937630191)
        //        AddressManager.sharedInstance.transformGeoPointToAddress(location.coordinate.latitude, longitude: location.coordinate.longitude) { (address) in
        //            print(address)
        //        }
        //        performSegueWithIdentifier("goToPetShops", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
