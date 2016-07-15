//
//  MainTabViewController.swift
//  PupCare
//
//  Created by Uriel Battanoli on 6/20/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import Parse

class MainTabViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.tabBar.tintColor = UIColor.redColor()
        
        //Promotions ViewController
        let vcPromotions = UIStoryboard(name: "Promotions", bundle: nil).instantiateInitialViewController()!
        vcPromotions.tabBarItem = UITabBarItem(title: "Promoções", image: UIImage(named: "promotionsIcon"), selectedImage: nil)
        
        //PetShops ViewController
        let vcPetShops = UIStoryboard(name: "Petshops", bundle: nil).instantiateInitialViewController()!
        vcPetShops.tabBarItem = UITabBarItem(title: "Pet Shops", image: UIImage(named: "petShopIcon"), selectedImage: nil)
        
        //Orders ViewController
        let vcOrders  = UIStoryboard(name: "Orders", bundle: nil).instantiateInitialViewController()!
        vcOrders.tabBarItem = UITabBarItem(title: "Pedidos", image: UIImage(named: "ordersIcon"), selectedImage: nil)
        
        //Profile ViewController
        var vcProfile = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()!
        
        if PFUser.currentUser() != nil{
            vcProfile = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController()!
        }
        vcProfile.tabBarItem = UITabBarItem(title: "Minha Conta", image: UIImage(named: "userIcon"), selectedImage: nil)
        
        self.viewControllers = [vcPetShops,vcPromotions,vcOrders,vcProfile]
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
