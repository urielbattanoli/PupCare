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
        
        self.promotionsTableView.separatorStyle = .none
        
        reloadPromotions()
        
        // Do any additional setup after loading the view.
    }

    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PromotionsCell", for: indexPath) as! PromotionsTableViewCell
        
        cell.indexPath = indexPath
        cell.promotion = self.allPromotions[(indexPath as NSIndexPath).row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPromotions.count
    }
    
    func reloadPromotions() {
        PromotionManager.getPromotionsList(10, longitude: 10, withinKilometers: 100000000) { (promotions, error) in
            if error == nil {
                print(promotions!)
                self.allPromotions = promotions!

                
                self.promotionsTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "PromotionDetails", sender: self.allPromotions[(indexPath as NSIndexPath).row])
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PromotionDetails" {
            let promotionDetails = segue.destination as! PromotionDetailsViewController
            
            promotionDetails.promotion = sender as? Promotion
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
