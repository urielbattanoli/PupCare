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

class InitialViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var CartViewResume: UIView!
    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        defaults.set(-1, forKey: "location")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        
        if UserManager.sharedInstance.user == nil{
            UserManager.sharedInstance.createUserByCurrentUser()
        }
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse){
            performSegue(withIdentifier: "goToPetShops", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: LocationManager delegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse{
            performSegue(withIdentifier: "goToPetShops", sender: nil)
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
