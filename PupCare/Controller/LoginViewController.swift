//
//  LoginViewController.swift
//  PupCare
//
//  Created by Luis Filipe Campani on 14/07/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    var initialConstant: CGFloat? = 132
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    
    @IBAction func dismissKeyboard(_ sender: AnyObject) {
        self.view.endEditing(true)
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
    
    // MARK: - keyboard
    func keyboardWillShow(notification: Notification){
        let keyboardFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardAnimationDuration :TimeInterval = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]) as! Double
        
        if self.initialConstant == nil{
            self.initialConstant = self.bottomConstraint.constant
        }
        
        self.bottomConstraint.constant = max(keyboardFrame!.size.height+10, self.initialConstant!)
        UIView.animate(withDuration: keyboardAnimationDuration, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        if self.logoImage.frame.height <= 70{
            UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                self.logoImage.alpha = 0
            }) { (successed) -> Void in
                self.logoImage.isHidden = true
            }
        }
    }
    
    func keyboardWillHide(notification: Notification){
        let keyboardAnimationDuration :TimeInterval = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]) as! Double
        
        self.bottomConstraint.constant = self.initialConstant!
        
        UIView.animate(withDuration: keyboardAnimationDuration, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        self.logoImage.alpha = 1
        self.logoImage.isHidden = false
    }
}
