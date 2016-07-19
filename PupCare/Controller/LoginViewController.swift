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

        // Do any additional setup after loading the view.
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
        UserManager.singInWithFacebook {
            if let tabController = self.navigationController?.childViewControllers[0] as? LoginViewController {
                tabController.view.layer.addAnimation(CustomTransitions.dismissCustomTransition(), forKey: kCATransition)
                tabController.dismissViewControllerAnimated(false, completion: nil)
            }
        }
    }
}
