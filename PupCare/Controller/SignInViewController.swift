//
//  SignInViewController.swift
//  PupCare
//
//  Created by Luis Filipe Campani on 20/07/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    
    @IBOutlet weak var usernameTextField: TXTAttributedStyle!
    @IBOutlet weak var passwordTextField: TXTAttributedStyle!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    
    @IBAction func signInAction(sender: AnyObject) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        if verifyFields() {
            UserManager.singInUser(username!, password: password!) { (usuario) in
                if usuario != nil {
                    let vcProfile : UIViewController! = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController()
                    vcProfile.tabBarItem = UITabBarItem(title: "Minha Conta", image: UIImage(named: "userIcon"), selectedImage: nil)
                    let profile = vcProfile.childViewControllers[0] as! MyProfileViewController
                    profile.user = usuario
                    
                    var viewControllers = self.tabBarController?.viewControllers ?? []
                    viewControllers[3] = vcProfile
                    
                    self.tabBarController?.setViewControllers(viewControllers, animated: false)
                } else {
                    self.setAlertBody("user nil")
                }
            }
        }
    }
    
    private func verifyFields() -> Bool{
        
        if passwordTextField.text == ""{
            return setAlertBody("password")
        } else if usernameTextField.text == "" {
            return setAlertBody("username")
        }
        return setAlertBody("")
    }
    
    private func setAlertBody(field : String) -> Bool{
        let alert = UIAlertController(title: "", message: "", preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(cancel)
        
        switch field {
        case "password":
            alert.message = "Por favor, isira a senha correta."
        case "username":
            alert.message = "Por Favor, insira um e-mail cadastrado."
        case "user nil":
            alert.message = "Usuário não cadastrado"
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