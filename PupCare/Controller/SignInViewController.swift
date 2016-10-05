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
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func signInAction(_ sender: AnyObject) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        if verifyFields() {
            UserManager.sharedInstance.singInUser(username!, password: password!) { (usuario) in
                if usuario != nil {
                    let vcLoginProfile : Login_ProfileViewController = self.tabBarController?.viewControllers![3] as! Login_ProfileViewController
                    vcLoginProfile.updateView()
                    
                    let profile = vcLoginProfile.profileViewController.childViewControllers[0] as! MyProfileViewController
                    profile.user = usuario!
                } else {
                    self.setAlertBody("user nil")
                }
            }
        }
    }
    
    fileprivate func verifyFields() -> Bool{
        
        if passwordTextField.text == ""{
            return setAlertBody("password")
        } else if usernameTextField.text == "" {
            return setAlertBody("username")
        }
        return setAlertBody("")
    }
    
    fileprivate func setAlertBody(_ field : String) -> Bool{
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
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
        self.present(alert, animated: true, completion: nil)
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
