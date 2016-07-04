//
//  PetShopsViewController.swift
//  PupCare
//
//  Created by Uriel Battanoli on 6/20/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class PetShopsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var petShopsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        petShopsTableView.dataSource = self
        petShopsTableView.delegate = self

        self.reloadPetShops()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PetShopCell", forIndexPath: indexPath) as! PetShopsTableViewCell
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    @IBAction func filterButton(sender: AnyObject) {
    
    
    }
    
    func reloadPetShops () {
        PetShop.getNearbyPetShops(10, longitude: 10, withinKilometers: 10, response: { (petshops, error) in
            
        })
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
