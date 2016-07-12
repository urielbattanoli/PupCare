//
//  PromotionsViewController.swift
//  PupCare
//
//  Created by Uriel Battanoli on 6/20/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class PromotionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var promotionsTableView: UITableView!

    var allPromotions: [Promotion] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.promotionsTableView.delegate = self
        self.promotionsTableView.dataSource = self
        
        var promo = Promotion()
        
        promo.promotionName = "Coleira para cachorro DogMax"
        promo.promotionDescription = "Coleira confeccionada em couro ecológico, para cães de pequeno porte."
        promo.lastPrice = 99.99
        promo.newPrice = 80.00
        
        
        allPromotions.append(promo)
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PromotionsCell", forIndexPath: indexPath) as! PromotionsTableViewCell
        
        cell.promotion = self.allPromotions[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPromotions.count
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
