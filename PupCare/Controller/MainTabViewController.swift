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
        self.tabBar.tintColor = UIColor(red: 102, green: 51, blue: 102)
        
        
        
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
        let vcLoginProfile = UIStoryboard(name: "Login+Profile", bundle: nil).instantiateInitialViewController()!
        vcLoginProfile.tabBarItem = UITabBarItem(title: "Minha Conta", image: UIImage(named: "userIcon"), selectedImage: UIImage(named: "userIconPressed"))
        
        self.viewControllers = [vcPromotions,vcPetShops,vcOrders,vcLoginProfile]
        
        
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
    func DidDismiss(_ removeView: Bool)
}
