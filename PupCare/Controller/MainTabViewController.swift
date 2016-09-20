//
//  MainTabViewController.swift
//  PupCare
//
//  Created by Uriel Battanoli on 6/20/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import Parse

class MainTabViewController: UITabBarController, UITabBarControllerDelegate, CartProtocol {
    
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    var controller = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.tabBar.tintColor = UIColor.white
        
        //Promotions ViewController
        let vcPromotions = UIStoryboard(name: "Promotions", bundle: nil).instantiateInitialViewController()!
        vcPromotions.tabBarItem = UITabBarItem(title: "Promoções", image: UIImage(named: "promotionIcon"), selectedImage: UIImage(named: "promotionIconPressed"))
        
        //PetShops ViewController
        let vcPetShops = UIStoryboard(name: "Petshops", bundle: nil).instantiateInitialViewController()!
        vcPetShops.tabBarItem = UITabBarItem(title: "Pet Shops", image: UIImage(named: "petShopIcon"), selectedImage: UIImage(named: "petShopIconPressed"))
        
        //Orders ViewController
        let vcOrders  = UIStoryboard(name: "Orders", bundle: nil).instantiateInitialViewController()!
        vcOrders.tabBarItem = UITabBarItem(title: "Pedidos", image: UIImage(named: "orderIcon"), selectedImage: UIImage(named: "orderIconPressed"))
        
        //Profile ViewController
        var vcProfile = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()!
        
        if PFUser.current() != nil{
            vcProfile = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController()!
        }
        vcProfile.tabBarItem = UITabBarItem(title: "Minha Conta", image: UIImage(named: "userIcon"), selectedImage: UIImage(named: "userIconPressed"))
        
        self.viewControllers = [vcPromotions,vcPetShops,vcOrders,vcProfile]
        
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        controller = storyBoard.instantiateViewController(withIdentifier: "CartOverView")
        controller.view.frame = CGRect(x: 0, y: self.view.frame.height - (self.tabBar.frame.height + 75), width: self.view.frame.width, height: 75)
        
        
        
        self.addChildViewController(controller)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ShowCart() {
        
        
        self.view.addSubview(controller.view)
        
        self.controller.view.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 75)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .transitionCurlUp, animations: {
            self.controller.view.frame = CGRect(x: 0, y: self.view.frame.height - (self.tabBar.frame.height + 75), width: self.view.frame.width, height: 75)
            
            }, completion: nil)
        
    }
    
    
    func HideCart() {
        
//        dispatch_async(dispatch_get_main_queue(), {
//                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        self.controller = storyBoard.instantiateViewControllerWithIdentifier("CartOverView")
//        
//            self.controller.view.removeFromSuperview()
      
//        self.view.addSubview(controller.view)
//        
//        self.controller.view.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 75)
//        
//        UIView.animateWithDuration(0.2, delay: 0, options: .TransitionCurlUp, animations: {
//            self.controller.view.frame = CGRect(x: 0, y: self.view.frame.height - (self.tabBar.frame.height + 75), width: self.view.frame.width, height: 75)
//            
//            }, completion: nil)

//            self.viewController.view.removeFromSuperview()
        
//            UIView.animateWithDuration(0.2, delay: 1, options: .CurveEaseIn, animations: {
//                self.controller.view.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 75)
//                }, completion: { (true) in
//                    
//                    
//            })
        
//        (self.controller as! CartOverViewController).removeFromView()
//
//        
    }
    
    func UpdateView(_ totalItensAndPrice:(Int,Double)) {
        (self.controller as! CartOverViewController).updateInfo(totalItensAndPrice)
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

protocol CartProtocol {
    func ShowCart()
    func UpdateView(_ totalItensAndPrice:(Int,Double))
    
}
    
protocol DismissProtocol {
    func DidDismiss(cause: DismissDelegateOptions)
}
