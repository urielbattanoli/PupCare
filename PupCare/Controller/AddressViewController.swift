//
//  AddressViewController.swift
//  PupCare
//
//  Created by Luis Filipe Campani on 09/08/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

@objc protocol AddAddressDelegate{
    optional func addressAdded(address: Address)
}

class AddressViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var streetTextView: TXTAttributedStyle!
    @IBOutlet weak var numberTextView: TXTAttributedStyle!
    @IBOutlet weak var complementTextView: TXTAttributedStyle!
    @IBOutlet weak var zipTextView: TXTAttributedStyle!
    @IBOutlet weak var neighbourhoodTextView: TXTAttributedStyle!
    @IBOutlet weak var cityTextView: TXTAttributedStyle!
    @IBOutlet weak var stateTextView: TXTAttributedStyle!
    @IBOutlet weak var addressNameTextView: TXTAttributedStyle!
    
    var searchZipTextField : UITextField!
    var location : CLLocation?
    let locationManager = CLLocationManager()
    var address: Address?
    weak var delegate : AddAddressDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        self.title = "Adicionar endereço"
        
        if let address = self.address{
            self.title = "Editar endereço"
            
            self.streetTextView.text = address.street
            self.numberTextView.text = "\(address.number)"
            self.complementTextView.text = address.additionalInfo
            self.zipTextView.text = address.zip
            self.neighbourhoodTextView.text = address.neighbourhood
            self.cityTextView.text = address.city
            self.stateTextView.text = address.state
            self.addressNameTextView.text = address.name
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configAlertTextView(textField: UITextField){
        textField.placeholder = "Ex: 90008890"
        textField.textAlignment = .Center
        searchZipTextField = textField
    }
    
    private func filledAllRequiredFields() -> Bool{
        if self.streetTextView.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "" ||
            self.numberTextView.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "" ||
            self.zipTextView.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "" ||
            self.cityTextView.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "" ||
            self.stateTextView.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "" ||
            self.neighbourhoodTextView.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == ""
        {
            return false
        }
        
        return true
    }
    
    private func disabletTextFieldInteraction(){
        self.streetTextView.userInteractionEnabled = false
        self.neighbourhoodTextView.userInteractionEnabled = false
        self.zipTextView.userInteractionEnabled = false
        self.cityTextView.userInteractionEnabled = false
        self.stateTextView.userInteractionEnabled = false
    }
    
    private func tranformJSONToData(json : JSON) -> [String:AnyObject]{
        var addressData = [String:AnyObject]()
        
        addressData["street"] = json["logradouro"].string
        addressData["number"] = 0
        addressData["neighbourhood"] = json["bairro"].string
        addressData["state"] = json["uf"].string
        addressData["city"] = json["localidade"].string
        addressData["zip"] = self.searchZipTextField.text!
        addressData["location"] = CLLocation()
        
        addressData["addressId"] = ""
        addressData["name"] = ""
        addressData["additionalInfo"] = ""
        
        if let address = self.address{
            addressData["addressId"] = address.addressId
            addressData["name"] = address.name
            addressData["additionalInfo"] = address.additionalInfo
        }
        
        return addressData
    }
    
    @IBAction func searchAddressByCurrentLocation(sender: AnyObject) {
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse){
            locationManager.startUpdatingLocation()
            
            let latitude = locationManager.location?.coordinate.latitude
            let longitude = locationManager.location?.coordinate.longitude
            
            AddressManager.sharedInstance.transformGeoPointToAddress(latitude!, longitude: longitude!) { (addressData) in
                self.disabletTextFieldInteraction()
                
                self.streetTextView.text = addressData["street"] as? String
                self.neighbourhoodTextView.text = addressData["neighbourhood"] as? String
                self.zipTextView.text = addressData["zip"] as? String
                self.cityTextView.text = addressData["city"] as? String
                self.stateTextView.text = addressData["state"] as? String
                
                var addressData = addressData
                
                if let address = self.address{
                    addressData["addressId"] = address.addressId
                    addressData["name"] = address.name
                    addressData["additionalInfo"] = address.additionalInfo
                }
                
                self.address = Address(data: addressData)
                
                self.address?.location = addressData["location"] as! CLLocation
            }
            
            locationManager.stopUpdatingLocation()
        }
        else{
            self.showAlertWhenDontAuthorization()
        }
    }
    
    func showAlertWhenDontAuthorization(){
        let alert = UIAlertController(title: "Serviço de localização desativado", message: "Por favor, ative o serviço de localização nos ajustes do seu aparelho", preferredStyle: .Alert)
        
        let settingsBt = UIAlertAction(title: "Ir aos Ajustes", style: .Default, handler: { (action) in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        })
        
        let cancelBt = UIAlertAction(title: "Cancelar", style: .Cancel, handler: { (action) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        })
        
        alert.addAction(cancelBt)
        alert.addAction(settingsBt)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func searchAddressByZipCode(sender: AnyObject) {
        let alert = UIAlertController(title: "Buscar endereço pelo CEP", message: "Digite o cep sem hífen", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler(configAlertTextView)
        alert.addAction(UIAlertAction(title: "Done", style: .Default, handler:{ (UIAlertAction) in
            
            AddressManager.sharedInstance.getZipInformation(self.searchZipTextField.text!, jsonResponse: { (json, error) in
                
                self.disabletTextFieldInteraction()
                
                self.streetTextView.text = json!["logradouro"].string
                self.neighbourhoodTextView.text = json!["bairro"].string
                self.zipTextView.text = self.searchZipTextField.text!
                self.cityTextView.text = json!["localidade"].string
                self.stateTextView.text = json!["uf"].string
                
                self.address = Address(data: self.tranformJSONToData(json!))
                
                AddressManager.sharedInstance.transformAddressToGeoPoint(self.address!, response: { (geoPoint) in
                    let lat = geoPoint.latitude
                    let lng = geoPoint.longitude
                    
                    self.address!.location = CLLocation(latitude: lat, longitude: lng)
                })
                
            })
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:nil))
        self.presentViewController(alert, animated: true, completion: {
        })
    }
    
    func completeAddressInformation(){
        if let street = streetTextView.text {
            address?.street = street
        }
        if let number = Int(numberTextView.text!){
            address?.number = NSNumber(integer: number)
        }
        if let additionalInfo = complementTextView.text {
            address?.additionalInfo = additionalInfo
        }
        if let neighbourhood = neighbourhoodTextView.text {
            address?.neighbourhood = neighbourhood
        }
        if let zip = zipTextView.text {
            address?.zip = zip
        }
        if let city = cityTextView.text {
            address?.city = city
        }
        if let state = stateTextView.text{
            address?.state = state
        }
        if let name = addressNameTextView.text {
            address?.name = name
        }
    }
    
    @IBAction func saveAddress(sender: AnyObject) {
        if filledAllRequiredFields() {
            completeAddressInformation()
            AddressManager.sharedInstance.saveUserNewAddress(self.address!, response: { (success, error) in
                if success {
                    self.delegate?.addressAdded?(self.address!)
                    self.navigationController?.popViewControllerAnimated(true)
                }
            })
        }
    }
}