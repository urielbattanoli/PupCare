//
//  CartOverViewController.swift
//  PupCare
//
//  Created by Anderson Rogério da Silva Gralha on 9/9/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class CartOverViewController: UIViewController {

    @IBOutlet weak var ShowCartButton: UIButton!
    @IBOutlet weak var ItensCountLabel: UILabel!
    @IBOutlet weak var TotalPriceLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ShowCartButton.layer.cornerRadius = 5
        
        //999 items
        //total: R$ 999,99
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
//        let totalItensAndPrice: (Int,Double) = Cart.sharedInstance.getTotalItemsAndPrice()
//        print(totalItensAndPrice)
//        
//        self.ItensCountLabel.text = "\(totalItensAndPrice.0) itens"
//        self.TotalPriceLabel.text = "Total: R$ \(totalItensAndPrice.1)"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateInfo(_ totalItensAndPrice: (Int,Double)) {
        self.ItensCountLabel.text = "\(totalItensAndPrice.0) itens"
        self.TotalPriceLabel.text = "Total: R$ \(totalItensAndPrice.1)"
    }

    func removeFromView() {
        
        self.dismiss(animated: true) { 
            
        }
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
