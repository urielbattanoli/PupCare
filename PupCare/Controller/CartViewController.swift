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

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.CartTableView.delegate = self
        self.CartTableView.dataSource = self
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var teste: String = "CartConfirmation"
        
        switch teste {
        case "CartPetShop":
            
            break
        case "CartProduct":
            
            break
        case "CartConfirmation":
            
            break
        default:
            break
        }
        
        let cell = UITableViewCell()
        
        
        
        
        return cell
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
