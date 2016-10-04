//
//  Login+ProfileViewController.swift
//  PupCare
//
//  Created by Luis Filipe Campani on 03/10/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import Parse

class Login_ProfileViewController: UIViewController {

    lazy var loginViewController : UIViewController = {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        
        var viewController = storyboard.instantiateInitialViewController()!
        
        return viewController
    }()
    
    lazy var profileViewController : UIViewController = {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "profileNavController")
        
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func applyConstraintsToRootViewController(){
        
    }
    
    func updateView(){
        if PFUser.current() != nil {
            self.removeViewControllerAsChildViewController(viewController: loginViewController)
            self.addViewControllerAsChildViewController(viewController: profileViewController)
        } else {
//            self.removeViewControllerAsChildViewController(viewController: profileViewController)
            self.addViewControllerAsChildViewController(viewController: loginViewController)
        }
    }
    
    private func addViewControllerAsChildViewController(viewController: UIViewController) {
        addChildViewController(viewController)

        let child = viewController.view!
        let father = self.view!

        father.addSubview(child)

        child.translatesAutoresizingMaskIntoConstraints = false
        
        let viewsDictionary = ["father":father, "child":child]
        
        let view_constraint_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[child(==father)]-0-|", options: .alignAllTrailing, metrics: nil, views: viewsDictionary)
        let view_constraint_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[child(==father)]-0-|", options: .alignAllTrailing, metrics: nil, views: viewsDictionary)
        
        NSLayoutConstraint.activate(view_constraint_V)
        NSLayoutConstraint.activate(view_constraint_H)
    }
    
    private func removeViewControllerAsChildViewController(viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
