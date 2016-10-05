//
//  LoginViewController.swift
//  PupCare
//
//  Created by Luis Filipe Campani on 14/07/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signUpAction(_ sender: AnyObject) {
        performSegue(withIdentifier: "signUpSegue", sender: nil)
    }
    
    @IBAction func signInAction(_ sender: AnyObject) {
        performSegue(withIdentifier: "signInSegue", sender: nil)
    }
    
    @IBAction func signUpWithFacebook(_ sender: AnyObject) {
        UserManager.sharedInstance.singInWithFacebook {
            if let vcLoginProfile = self.tabBarController?.viewControllers![3].childViewControllers[0].childViewControllers[0] as? Login_ProfileViewController  {
                vcLoginProfile.updateView()
            }
        }
    }
}
