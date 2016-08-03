//
//  CartViewController.swift
//  PupCare
//
//  Created by Anderson Rogério da Silva Gralha on 7/28/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var CartTableView: UITableView!
    
    
    var sections: [ProductCart] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.CartTableView.delegate = self
        self.CartTableView.dataSource = self
        
        for (_, productCart) in Cart.sharedInstance.cartProduct.productList {
            sections.append(productCart)
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].products.count + sections[section].promotions.count + 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var teste: String = "CartConfirmation"
        var cell = UITableViewCell()
        
        switch  {
        case "CartPetShop":
            cell = tableView.dequeueReusableCellWithIdentifier("CartPetShop", forIndexPath: indexPath) as! CartTableViewCell
            break
        case "CartProduct":
            cell = tableView.dequeueReusableCellWithIdentifier("CartProduct", forIndexPath: indexPath) as! CartTableViewCell
            break
        case "CartConfirmation":
            cell = tableView.dequeueReusableCellWithIdentifier("CartConfirmation", forIndexPath: indexPath) as! CartTableViewCell
            break
        default:
            break
        }
        
        
        
        
        
        
        
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
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
