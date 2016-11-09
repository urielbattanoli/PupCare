//
//  AddressViewController.swift
//  PupCare
//
//  Created by Luis Filipe Campani on 09/08/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import CoreLocation
import Gloss

struct AddressJson : Decodable{
    
    let cep : String!
    let logradouro : String!
    let complemento : String!
    let bairro : String!
    let localidade : String!
    let uf : String!
    let unidade : String!
    let ibge : String!
    let gia : String!
    
    init?(json : JSON){
        self.cep = "cep" <~~ json
        self.logradouro = "logradouro" <~~ json
        self.complemento = "complemento" <~~ json
        self.bairro = "bairro" <~~ json
        self.localidade = "localidade" <~~ json
        self.uf = "uf" <~~ json
        self.unidade = "unidade" <~~ json
        self.ibge = "ibge" <~~ json
        self.gia = "gia" <~~ json
    }
}


@objc protocol AddAddressDelegate{
    @objc optional func addressAdded(_ address: Address)
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
        
        self.addButtonDoneOnKeyboard()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func configAlertTextView(_ textField: UITextField){
        textField.placeholder = "Ex: 90008890"
        textField.textAlignment = .center
        searchZipTextField = textField
    }
    
    fileprivate func filledAllRequiredFields() -> Bool{
        if self.streetTextView.text?.trimmingCharacters(in: CharacterSet.whitespaces) == "" ||
            self.numberTextView.text?.trimmingCharacters(in: CharacterSet.whitespaces) == "" ||
            self.zipTextView.text?.trimmingCharacters(in: CharacterSet.whitespaces) == "" ||
            self.cityTextView.text?.trimmingCharacters(in: CharacterSet.whitespaces) == "" ||
            self.stateTextView.text?.trimmingCharacters(in: CharacterSet.whitespaces) == "" ||
            self.neighbourhoodTextView.text?.trimmingCharacters(in: CharacterSet.whitespaces) == ""
        {
            return false
        }
        
        return true
    }
    
    fileprivate func disabletTextFieldInteraction(){
        self.streetTextView.isUserInteractionEnabled = false
        self.neighbourhoodTextView.isUserInteractionEnabled = false
        self.zipTextView.isUserInteractionEnabled = false
        self.cityTextView.isUserInteractionEnabled = false
        self.stateTextView.isUserInteractionEnabled = false
    }
    
    fileprivate func tranformJSONToData(_ json : JSON) -> [String:AnyObject]{
        var addressData = [String:AnyObject]()
        
        let addressJson = AddressJson(json: json)!
            
            addressData["street"] = addressJson.logradouro as AnyObject?
            addressData["number"] = 0 as AnyObject?
            addressData["neighbourhood"] = addressJson.bairro as AnyObject?
            addressData["state"] = addressJson.uf as AnyObject?
            addressData["city"] = addressJson.localidade as AnyObject?
            addressData["zip"] = self.searchZipTextField.text! as AnyObject?
            addressData["location"] = CLLocation()
            
            addressData["objectId"] = "" as AnyObject?
            addressData["name"] = "" as AnyObject?
            addressData["additionalInfo"] = "" as AnyObject?
            
        
        if let address = self.address{
            addressData["objectId"] = address.addressId as AnyObject?
            addressData["name"] = address.name as AnyObject?
            addressData["additionalInfo"] = address.additionalInfo as AnyObject?
        }
        
        
        return addressData
    }
    
    fileprivate func addButtonDoneOnKeyboard(){
        let doneToolbar = UIToolbar()
        
        self.zipTextView.inputAccessoryView = doneToolbar
        self.addressNameTextView.inputAccessoryView = doneToolbar
        self.streetTextView.inputAccessoryView = doneToolbar
        self.cityTextView.inputAccessoryView = doneToolbar
        self.complementTextView.inputAccessoryView = doneToolbar
        self.stateTextView.inputAccessoryView = doneToolbar
        self.numberTextView.inputAccessoryView = doneToolbar
        self.neighbourhoodTextView.inputAccessoryView = doneToolbar
    }
    
    @IBAction func searchAddressByCurrentLocation(_ sender: AnyObject) {
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse){
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
                    addressData["objectId"] = address.addressId as AnyObject?
                    addressData["name"] = address.name as AnyObject?
                    addressData["additionalInfo"] = address.additionalInfo as AnyObject?
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
        let alert = UIAlertController(title: "Serviço de localização desativado", message: "Por favor, ative o serviço de localização nos ajustes do seu aparelho", preferredStyle: .alert)
        
        let settingsBt = UIAlertAction(title: "Ir aos Ajustes", style: .default, handler: { (action) in
//            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        })
        
        let cancelBt = UIAlertAction(title: "Cancelar", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(cancelBt)
        alert.addAction(settingsBt)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func searchAddressByZipCode(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Buscar endereço pelo CEP", message: "Digite o cep sem hífen", preferredStyle: .alert)
        alert.addTextField(configurationHandler: configAlertTextView)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler:{ (UIAlertAction) in
            
            AddressManager.sharedInstance.getZipInformation(self.searchZipTextField.text!, jsonResponse: { (json, error) in
                
                let addressJson = AddressJson(json: json!)!
                
                self.disabletTextFieldInteraction()
                
                self.streetTextView.text = addressJson.logradouro //json!["logradouro"].string
                self.neighbourhoodTextView.text = addressJson.bairro// !["bairro"].string
                self.zipTextView.text = self.searchZipTextField.text!
                self.cityTextView.text = addressJson.localidade// !["localidade"].string
                self.stateTextView.text = addressJson.uf// json!["uf"].string
                
                self.address = Address(data: self.tranformJSONToData(json!))
                
                AddressManager.sharedInstance.transformAddressToGeoPoint(self.address!, response: { (geoPoint) in
                    let lat = geoPoint?.latitude
                    let lng = geoPoint?.longitude
                    
                    self.address!.location = CLLocation(latitude: lat!, longitude: lng!)
                })
                
            })
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        self.present(alert, animated: true, completion: {
        })
    }
    
    func completeAddressInformation(){
        if let street = streetTextView.text {
            address?.street = street
        }
        if let number = Int(numberTextView.text!){
            address?.number = NSNumber(value: number as Int)
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
    
    @IBAction func saveAddress(_ sender: AnyObject) {
        if filledAllRequiredFields() {
            completeAddressInformation()
            AddressManager.sharedInstance.saveUserNewAddress(self.address!, response: { (success, error) in
                if success {
                    self.delegate?.addressAdded?(self.address!)
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }
}
