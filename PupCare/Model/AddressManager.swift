//
//  AddressManager.swift
//  PupCare
//
//  Created by Luis Filipe Campani on 25/07/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import Parse
import AddressBookUI
import Gloss

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class AddressManager: NSObject {
    
    static let sharedInstance = AddressManager()
    
    func getZipInformation(_ zip: String, jsonResponse: @escaping (_ json: JSON?, _ error: Error?) -> ()) {
        let urlTo = "https://viacep.com.br/ws/\(zip)/json/unicode/"
        
        Alamofire.request(urlTo).responseJSON { (response) in
            if let json = response.result.value as? JSON{
                jsonResponse(json, nil)
            }
        }
    }
    
    func saveUserNewAddress(_ address: Address, response: @escaping (Bool, Error?)->()){
        let addressPFObject = AddressManager.sharedInstance.transformAddressToPFObject(address)
        addressPFObject.saveInBackground { (suc, err) in
            response(suc, err)
        }
    }
    
    fileprivate func transformAddressToPFObject(_ address: Address) -> PFObject {
        let addressAsPFObject = PFObject(className: "Address")
        if !address.addressId.isEmpty {
            addressAsPFObject.objectId = address.addressId
        }
        addressAsPFObject["userId"] = PFUser.current()
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
    
    func transformAddressToGeoPoint(_ address: Address, response:@escaping (_ geoPoint: CLLocationCoordinate2D)->()){
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
                
                response((location?.coordinate)!)
            }
        })
    }
    
    func transformGeoPointToAddress(_ latitude: CLLocationDegrees, longitude: CLLocationDegrees, response:@escaping (_ data: [String:AnyObject])->()) {
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
                let city = cityState.substring(from: cityState.startIndex).substring(to: cityState.characters.index(cityState.endIndex, offsetBy: -5))
                
                addressDict["objectId"] = "" as AnyObject?
                addressDict["name"] = "" as AnyObject?
                addressDict["street"] = pmDict!["Thoroughfare"] as AnyObject?
                addressDict["number"] = 0 as AnyObject?
                addressDict["additionalInfo"] = "" as AnyObject?
                addressDict["neighbourhood"] = pmDict!["SubLocality"] as AnyObject?
                addressDict["state"] = pmDict!["State"] as AnyObject?
                addressDict["city"] = city as AnyObject?
                addressDict["zip"] = "\(pmDict!["ZIP"]!)\(pmDict!["PostCodeExtension"]!)" as AnyObject?
                addressDict["location"] = CLLocation(latitude: latitude, longitude: longitude)
                
                response(addressDict)
            }
        })
    }
    
    func getAddressListFromUser(_ userId: String, block: @escaping ([Address])->()){
        let param = ["userId" : userId]
        PFCloud.callFunction(inBackground: "getUserAddresses", withParameters: param) { (addresses, error) in
            
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
    
    func removeAddressFromParse(_ address: Address){
        let pfAddress = self.transformAddressToPFObject(address)
        pfAddress.deleteInBackground { (success, error) in
            if !success{
                print(error)
            }
        }
    }
}
