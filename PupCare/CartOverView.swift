//
//  CartOverViewController.swift
//  PupCare
//
//  Created by Anderson Rogério da Silva Gralha on 9/9/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class CartOverViewController: UIViewController, DismissProtocol {

    @IBOutlet weak var ShowCartButton: UIButton!
    @IBOutlet weak var ItensCountLabel: UILabel!
    @IBOutlet weak var TotalPriceLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ShowCartButton.layer.cornerRadius = 5
        
        //Promotions ViewController
        
        
        

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
        
        self.dismiss(animated: true, completion: nil)
        
        self.view.frame = CGRect(x: 0, y: self.parent!.view.frame.height + 75, width: self.view.frame.width, height: 75)
    }

    func DidDismiss(cause: DismissDelegateOptions) {
        switch cause {
        case .CartEmpty:
            self.removeFromView()
            break
        case .UpdateCart:
            self.updateInfo(Cart.sharedInstance.getTotalItemsAndPrice())
            break
        }
    }
    
    @IBAction func ShowCart(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Cart", bundle: nil)
        
        let nvcCart = storyboard.instantiateViewController(withIdentifier: "CartViewController")
        
        nvcCart.modalTransitionStyle = .coverVertical
        let vcCart = nvcCart.childViewControllers[0] as! CartViewController
        vcCart.CartDismissDelegate = self
        
        self.present(nvcCart, animated: true, completion: nil)
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
