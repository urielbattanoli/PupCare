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
import Parse

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
    
    var location : PFGeoPoint?
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        // Do any additional setup after loading the view.
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
    
    @IBAction func searchAddressByCurrentLocation(sender: AnyObject) {
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
            self.location = (addressData["location"] as? PFGeoPoint)!
        }
        
        locationManager.stopUpdatingLocation()
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
                
                var addressData = [String:AnyObject]()
                
                addressData["userId"] = ""
                addressData["name"] = ""
                addressData["street"] = json!["logradouro"].string
                addressData["number"] = 759
                addressData["neighbourhood"] = json!["bairro"].string
                addressData["state"] = json!["uf"].string
                addressData["city"] = json!["localidade"].string
                addressData["zip"] = self.searchZipTextField.text!
                addressData["location"] = PFGeoPoint()
                addressData["additionalInfo"] = ""
                
                
                let address = Address(data: addressData)
                
                AddressManager.sharedInstance.transformAddressToGeoPoint(address, response: { (geoPoint) in
                    let lat = geoPoint.latitude
                    let lng = geoPoint.longitude
                    
                    address.location = CLLocation(latitude: lat, longitude: lng)
                })
                
            })
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:nil))
        self.presentViewController(alert, animated: true, completion: {
        })
    }
    
    @IBAction func saveAddress(sender: AnyObject) {
        
    }
}