//
//  SignUpViewController.swift
//  PupCare
//
//  Created by Luis Filipe Campani on 13/07/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet var name: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var passwordConfirmation: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.layer.borderColor = UIColor(red: 220, green: 220, blue: 220, alpha: 1).CGColor
        name.layer.borderWidth = 1
        name.borderStyle = UITextBorderStyle.Line
        
        email.layer.borderColor = UIColor(red: 220, green: 220, blue: 220, alpha: 1).CGColor
        email.layer.borderWidth = 1
        email.borderStyle = UITextBorderStyle.Line
        
        password.layer.borderColor = UIColor(red: 220, green: 220, blue: 220, alpha: 1).CGColor
        password.layer.borderWidth = 1
        password.borderStyle = UITextBorderStyle.Line
        
        passwordConfirmation.layer.borderColor = UIColor(red: 220, green: 220, blue: 220, alpha: 1).CGColor
        passwordConfirmation.layer.borderWidth = 1
        passwordConfirmation.borderStyle = UITextBorderStyle.Line

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
