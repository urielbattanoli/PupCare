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
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signUpAction(sender: AnyObject) {
        performSegueWithIdentifier("signUpSegue", sender: nil)
    }
    
    @IBAction func signInAction(sender: AnyObject) {
        performSegueWithIdentifier("signInSegue", sender: nil)
    }
    
    @IBAction func signUpWithFacebook(sender: AnyObject) {
        UserManager.sharedInstance.singInWithFacebook {
            let vcProfile : UIViewController! = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController()
            vcProfile.tabBarItem = UITabBarItem(title: "Minha Conta", image: UIImage(named: "userIcon"), selectedImage: nil)
            
            var viewControllers = self.tabBarController?.viewControllers ?? []
            viewControllers[3] = vcProfile
            
            self.tabBarController?.setViewControllers(viewControllers, animated: false)
        }
    }
}
