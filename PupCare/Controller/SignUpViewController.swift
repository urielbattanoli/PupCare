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
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 94, green: 23, blue: 96)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    
    @IBAction func didPressSignUp(_ sender: AnyObject) {
        if verifyFields() {
            UserManager.sharedInstance.singUpUser(name.text! , email: email.text!, password: password.text!, block: { (succeeded, message, userCreated) in
                if self.setAlertBody("",messageReceived: message) {
                    self.dismiss(animated: false, completion: nil)
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileAfterSignUpSegue" {
            if let containerControler = self.tabBarController?.viewControllers![3], let navController = containerControler.childViewControllers[0] as? UINavigationController, let vcLoginProfile = navController.childViewControllers[0] as? Login_ProfileViewController  {
                vcLoginProfile.updateView()
                let profile = vcLoginProfile.profileViewController.childViewControllers[0] as! MyProfileViewController
                profile.user = (sender as? User)
            }
        }
    }
    
    fileprivate func verifyFields() -> Bool{
        
        if password.text != passwordConfirmation.text {
            return setAlertBody("password")
        } else if email.text == "" {
            return setAlertBody("email")
        } else if name.text == ""{
            return setAlertBody("name")
        }
        return setAlertBody("")
    }
    
    fileprivate func setAlertBody(_ field : String) -> Bool{
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
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
        self.present(alert, animated: true, completion: nil)
        return false
    }
    
    fileprivate func setAlertBody(_ field : String, messageReceived: String) -> Bool{
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancel)

        switch field {
        case "signUp" where messageReceived.contains("username"):
            alert.message = "E-mail já cadastrado"
        default:
            return true
        }
        self.present(alert, animated: true, completion: nil)
        return false
    }
}
