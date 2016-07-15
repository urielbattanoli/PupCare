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
    
    
    
    @IBAction func didPressSignUp(sender: AnyObject) {
        if verifyFields() {
            UserManager.singUpUser(name.text! , email: email.text!, password: password.text!, block: { (succeeded, message, userCreated) in
                if self.setAlertBody("",message: message) {
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
            return setAlertBody("password",message: "")
        } else if email.text == "" {
            return setAlertBody("email",message: "")
        } else if name.text == ""{
            return setAlertBody("name",message: "")
        }
        return setAlertBody("",message: "")
    }
    
    private func setAlertBody(field : String, message: String) -> Bool{
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
        case "signUp" where message.containsString("username"):
            alert.message = "E-mail já cadastrado"
        default:
            return true
        }
        self.presentViewController(alert, animated: true, completion: nil)
        return false
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
