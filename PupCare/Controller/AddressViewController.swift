//
//  AddressViewController.swift
//  PupCare
//
//  Created by Luis Filipe Campani on 09/08/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import CoreLocation

class AddressViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var streetTextView: TXTAttributedStyle!
    @IBOutlet weak var numberTextView: TXTAttributedStyle!
    @IBOutlet weak var complementTextView: TXTAttributedStyle!
    @IBOutlet weak var zipTextView: TXTAttributedStyle!
    @IBOutlet weak var neighbourhoodTextView: TXTAttributedStyle!
    @IBOutlet weak var cityTextView: TXTAttributedStyle!
    @IBOutlet weak var stateTextView: TXTAttributedStyle!
    @IBOutlet weak var addressNameTextView: TXTAttributedStyle!
    
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
    
    @IBAction func searchAddressByCurrentLocation(sender: AnyObject) {
        locationManager.startUpdatingLocation()
        
        let latitude = locationManager.location?.coordinate.latitude
        let longitude = locationManager.location?.coordinate.longitude
        
        AddressManager.sharedInstance.transformGeoPointToAddress(latitude!, longitude: longitude!) { (addressData) in
            self.streetTextView.userInteractionEnabled = false
            self.neighbourhoodTextView.userInteractionEnabled = false
            self.zipTextView.userInteractionEnabled = false
            self.cityTextView.userInteractionEnabled = false
            self.stateTextView.userInteractionEnabled = false
            
            self.streetTextView.text = addressData["street"] as? String
            self.neighbourhoodTextView.text = addressData["neighbourhood"] as? String
            self.zipTextView.text = addressData["zip"] as? String
            self.cityTextView.text = addressData["city"] as? String
            self.stateTextView.text = addressData["state"] as? String
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func searchAddressByZipCode(sender: AnyObject) {
    }
    
    @IBAction func saveAddress(sender: AnyObject) {
    }
}