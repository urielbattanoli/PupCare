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
        self.tabBar.tintColor = UIColor(red: 250, green: 250, blue: 250)
        
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
        
        if PFUser.currentUser() != nil{
            vcProfile = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController()!
        }
        vcProfile.tabBarItem = UITabBarItem(title: "Minha Conta", image: UIImage(named: "userIcon"), selectedImage: UIImage(named: "userIconPressed"))
        
        self.viewControllers = [vcPromotions,vcPetShops,vcOrders,vcProfile]
        
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
