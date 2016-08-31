//
//  AddressManager.swift
//  PupCare
//
//  Created by Luis Filipe Campani on 25/07/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import Parse
import AddressBookUI

class AddressManager: NSObject {
    
    static let sharedInstance = AddressManager()
    
    func getZipInformation(zip: String, jsonResponse: (json: JSON?, error: NSError?) -> ()) {
        let urlTo = "https://viacep.com.br/ws/\(zip)/json/unicode/"
        Alamofire.request(.GET, urlTo).responseJSON { (response) in
            let json = JSON(data: response.data!)
            print(json)
            jsonResponse(json: json, error: nil)
        }
    }
    
    func saveUserNewAddress(address: Address, response: (Bool, NSError?)->()){
        let addressPFObject = AddressManager.sharedInstance.transformAddressToPFObject(address)
        
        addressPFObject.saveInBackgroundWithBlock { (success, error) in
            response(success,error)
        }
    }
    
    private func transformAddressToPFObject(address: Address) -> PFObject {
        let addressAsPFObject = PFObject(className: "Address")
        if !address.addressId.isEmpty {
            addressAsPFObject.objectId = address.addressId
        }
        addressAsPFObject["userId"] = PFUser.currentUser()
        addressAsPFObject["street"] = address.street
        addressAsPFObject["zip"] = address.zip
        addressAsPFObject["number"] = address.number
        addressAsPFObject["city"] = address.city
        addressAsPFObject["neighbourhood"] = address.neighbourhood
        addressAsPFObject["location"] = PFGeoPoint(location: address.location)
        addressAsPFObject["state"] = address.state
        addressAsPFObject["name"] = address.name
        
        return addressAsPFObject
    }
    
    func transformAddressToGeoPoint(address: Address, response:(geoPoint: CLLocationCoordinate2D)->()){
        let addressString = "\(address.street), \(address.number) \(address.city)"
        print(addressString)
        CLGeocoder().geocodeAddressString(addressString, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error)
                return
            }
            if placemarks?.count > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                
                response(geoPoint: (location?.coordinate)!)
            }
        })
    }
    
    func transformGeoPointToAddress(latitude: CLLocationDegrees, longitude: CLLocationDegrees, response:(data: [String:AnyObject])->()) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            else if placemarks?.count > 0 {
                let pm = placemarks![0]
                let pmDict = pm.addressDictionary
                
                var addressDict = [String:AnyObject]()
                let cityState = (pmDict!["FormattedAddressLines"] as! [String])[2]
                let city = cityState.substringFromIndex(cityState.startIndex).substringToIndex(cityState.endIndex.advancedBy(-5))
                
                addressDict["objectId"] = ""
                addressDict["name"] = ""
                addressDict["street"] = pmDict!["Thoroughfare"]
                addressDict["number"] = 0
                addressDict["additionalInfo"] = ""
                addressDict["neighbourhood"] = pmDict!["SubLocality"]
                addressDict["state"] = pmDict!["State"]
                addressDict["city"] = city
                addressDict["zip"] = "\(pmDict!["ZIP"]!)\(pmDict!["PostCodeExtension"]!)"
                addressDict["location"] = CLLocation(latitude: latitude, longitude: longitude)
                
                response(data: addressDict)
            }
        })
    }
    
    func getAddressListFromUser(userId: String, block: ([Address])->()){
        let param = ["userId" : userId]
        PFCloud.callFunctionInBackground("getUserAddresses", withParameters: param) { (addresses, error) in
            
            var addressList = [Address]()
            
            if let addresses = addresses as? [PFObject]{
                for address in addresses{
                    let object = Address(parseObject: address)
                    addressList.append(object)
                }
            }
            block(addressList)
        }
    }
    
    func removeAddressFromParse(address: Address){
        let pfAddress = self.transformAddressToPFObject(address)
        pfAddress.deleteInBackgroundWithBlock { (success, error) in
            if !success{
                print(error)
            }
        }
    }
}
