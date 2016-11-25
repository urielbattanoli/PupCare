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

class InitialViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet var CartViewResume: UIView!
    
    
    let locationManager = CLLocationManager()
    let defaults = UserDefaults.standard
    
    var validCep = false
    var alertCEP = UIAlertController(title: "Digite seu CEP", message: "Por favor, insira o CEP desejado", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.delegate = self
        alertRequestLocation()
        
        if UserManager.sharedInstance.user == nil{
            UserManager.sharedInstance.createUserByCurrentUser()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alertRequestLocation() {
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse) {
            performSegue(withIdentifier: "goToPetShops", sender: nil)
            
        } else if ((defaults.object(forKey: "location") as? Int) != nil) && ((defaults.object(forKey: "geopoint") as? String) != nil) {
            performSegue(withIdentifier: "goToPetShops", sender: nil)
        } else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied {
            
            let alert2 = UIAlertController(title: "Informe-nos sua Localização", message: "PupCare funciona com base na sua localização. Para ativar a localização você deve ir até as configurações, ou adicionar um CEP.", preferredStyle: UIAlertControllerStyle.alert)
            alert2.addAction(UIAlertAction(title: "Buscar pelo seu CEP", style: .default , handler: { action in
                self.requestCEP()
            }))
            self.present(alert2, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Informe-nos sua Localização", message: "PupCare funciona com base na sua localização. Ative-a para serem mostradas todas as pet shops próximas à você.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ativar e buscar pelo GPS", style: .default , handler: { action in
                print("Ativou")
                if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied {
                } else {
                    self.ativou()
                }
            }))
            alert.addAction(UIAlertAction(title: "Buscar pelo seu CEP", style: .default , handler: { action in
                self.requestCEP()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    func requestCEP() {
        
        alertCEP.addTextField { (textField) in
            textField.placeholder = "CEP"
            textField.delegate = self
            textField.keyboardType = .numberPad
        }
        
        alertCEP.addAction(UIAlertAction(title: "OK", style: .default , handler: { action in
            let textField = self.alertCEP.textFields?.first
            
            
            self.defaults.set(0, forKey: "location")
            AddressManager.sharedInstance.getZipInformation(textField!.text!, jsonResponse: { (json, error) in
                
                print("ENDEREÇO")
                //print(json)
                
                if let erro = json?["erro"] {
                    print(erro)
                    self.alertCEP = UIAlertController(title: "Digite seu CEP", message: "Por favor, insira o seu CEP corretamente para que possamos buscar petshops próximas.", preferredStyle: .alert)
                    self.requestCEP()
                    
                } else {
                    
                    let addressJson = AddressJson(json: json!)!
                    
                    var addressDict = [String:AnyObject]()
                    
                    addressDict["objectId"] = "" as AnyObject?
                    addressDict["name"] = "" as AnyObject?
                    addressDict["street"] = addressJson.logradouro as AnyObject?
                    addressDict["number"] = 0 as AnyObject?
                    addressDict["additionalInfo"] = "" as AnyObject?
                    addressDict["neighbourhood"] = addressJson.bairro as AnyObject?
                    addressDict["state"] = addressJson.uf as AnyObject?
                    addressDict["city"] = addressJson.localidade as AnyObject?
                    addressDict["zip"] = addressJson.cep as AnyObject?
                    addressDict["location"] = CLLocation()
                    
                    let address = Address(data: addressDict)
                    
                    AddressManager.sharedInstance.transformAddressToGeoPoint(address, response: { (geopoint) in
                        //print(geopoint)
                        self.defaults.set("\(geopoint!.latitude)%\(geopoint!.longitude)", forKey: "geopoint")
                    })
                    self.performSegue(withIdentifier: "goToPetShops", sender: nil)
                }
                
            })
        }))
        
        alertCEP.actions.last?.isEnabled = false
        
        self.present(alertCEP, animated: true, completion: nil)
    }
    
    
    func ativou() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: Text Field Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        if newLength == 8 {
            alertCEP.actions.last?.isEnabled = true
        } else {
            alertCEP.actions.last?.isEnabled = false
        }
        
        return newLength < 9
    }
    
    // MARK: LocationManager delegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            self.defaults.set(-1, forKey: "location")
            performSegue(withIdentifier: "goToPetShops", sender: nil)
        }
        if status == CLAuthorizationStatus.denied {
            alertRequestLocation()
        }
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
