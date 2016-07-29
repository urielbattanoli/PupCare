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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    
    
    @IBAction func didPressSignUp(sender: AnyObject) {
        if verifyFields() {
            UserManager.sharedInstance.singUpUser(name.text! , email: email.text!, password: password.text!, block: { (succeeded, message, userCreated) in
                if self.setAlertBody("",messageReceived: message) {
                    self.dismissViewControllerAnimated(false, completion: nil)
                }
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "profileAfterSignUpSegue" {
            let profileVC = segue.destinationViewController.childViewControllers[0] as! MyProfileViewController
            
            profileVC.user = sender as? User
            
        }
    }
    
    private func verifyFields() -> Bool{
        
        if password.text != passwordConfirmation.text {
            return setAlertBody("password")
        } else if email.text == "" {
            return setAlertBody("email")
        } else if name.text == ""{
            return setAlertBody("name")
        }
        return setAlertBody("")
    }
    
    private func setAlertBody(field : String) -> Bool{
        let alert = UIAlertController(title: "", message: "", preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(cancel)
        
        switch field {
        case "password":
            alert.message = "Senha e Confirmação de Senha não conferem. Por favor, insira senhas iguas."
        case "email":
            alert.message = "Por favor, insira um e-mail válido"
        case "name":
            alert.message = "Por Favor, insira um e-mail válido"
        default:
            return true
        }
        self.presentViewController(alert, animated: true, completion: nil)
        return false
    }
    
    private func setAlertBody(field : String, messageReceived: String) -> Bool{
        let alert = UIAlertController(title: "", message: "", preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(cancel)

        switch field {
        case "signUp" where messageReceived.containsString("username"):
            alert.message = "E-mail já cadastrado"
        default:
            return true
        }
        self.presentViewController(alert, animated: true, completion: nil)
        return false
    }
}
