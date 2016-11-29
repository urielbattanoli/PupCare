//
//  ProfileContainerViewController.swift
//  PupCare
//
//  Created by Luis Filipe Campani on 05/10/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class ProfileContainerViewController: UIViewController, ChangeContainerNavBarColor {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeNavBarColor(controllerName: String) {
        switch controllerName {
        case "Profile":
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 77, green: 38, blue: 77)
        case "Login":
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.barTintColor = UIColor.white
        default:
            break
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedSegue"{
            let loginProfile = segue.destination as? Login_ProfileViewController
            loginProfile?.delegate = self
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
