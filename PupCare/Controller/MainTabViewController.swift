//
//  MainTabViewController.swift
//  PupCare
//
//  Created by Uriel Battanoli on 6/20/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.tabBar.tintColor = UIColor.redColor()
        
        //PetShops ViewController
        let vcPetShops = UIStoryboard(name: "Petshops", bundle: nil).instantiateInitialViewController()!
        vcPetShops.tabBarItem = UITabBarItem(title: "Pet Shops", image: UIImage(named: "Paws"), selectedImage: nil)
        
        //Promotions ViewController
        let vcPromotions = UIStoryboard(name: "Promotions", bundle: nil).instantiateInitialViewController()!
        vcPromotions.tabBarItem = UITabBarItem(title: "Promoções", image: nil, selectedImage: nil)
        
        //Orders ViewController
        let vcOrders  = UIStoryboard(name: "Orders", bundle: nil).instantiateInitialViewController()!
        vcOrders.tabBarItem = UITabBarItem(title: "Pedidos", image: nil, selectedImage: nil)
        
        //Cart ViewController
        let vcCart = UIStoryboard(name: "Cart", bundle: nil).instantiateInitialViewController()!
        vcCart.tabBarItem = UITabBarItem(title: "Carrinho", image: nil, selectedImage: nil)
        
        self.viewControllers = [vcPetShops,vcPromotions,vcOrders,vcCart]
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
