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
    
    var allPetShops: [PetShop] = []
    
    var filteredPetShops: [PetShop] = []
    
    var refreshControl: UIRefreshControl!
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let petShop1 = PetShop()
        petShop1.name = "Pets Mimados"
        petShop1.address = "Orfanatrofio"
        allPetShops.append(petShop1)
        
        let petShop2 = PetShop()
        petShop2.name = "Pets Furiosos"
        petShop2.address = "PUCRS"
        allPetShops.append(petShop2)
        
        let petShop3 = PetShop()
        petShop3.name = "Pets Shows"
        petShop3.address = "Nonoai"
        allPetShops.append(petShop3)
        
        let petShop4 = PetShop()
        petShop4.name = "Pets Carinhosos"
        petShop4.address = "Protásio Alves"
        allPetShops.append(petShop4)
        
        let petShop5 = PetShop()
        petShop5.name = "Pets Mimados"
        petShop5.address = "Orfanatrofio"
        allPetShops.append(petShop5)
        
        let petShop6 = PetShop()
        petShop6.name = "Pets Correndo"
        petShop6.address = "Osvaldo Aranha"
        allPetShops.append(petShop6)
        
        
        petShopsTableView.dataSource = self
        petShopsTableView.delegate = self

        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Puxe para atualizar")
        refreshControl.addTarget(self, action: #selector(PetShopsViewController.reloadPetShops), forControlEvents: UIControlEvents.ValueChanged)
        
        petShopsTableView.addSubview(refreshControl)
        
        searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchBar.scopeButtonTitles = Array()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        petShopsTableView.tableHeaderView = searchController.searchBar
        
        
        searchController.searchBar.sizeToFit()
        
        self.reloadPetShops()
        
        self.petShopsTableView.contentOffset = CGPointMake(0, self.searchController.searchBar.frame.size.height)
        
        // Do any additional setup after loading the view.
    }

    func filterPetShopsForSearchText(searchText: String, scope: String = "All") {
        filteredPetShops = allPetShops.filter { petShop in
            return petShop.name.lowercaseString.containsString(searchText.lowercaseString)
        }

        petShopsTableView.reloadData()
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 44;
//    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PetShopCell", forIndexPath: indexPath) as! PetShopsTableViewCell
        
        let petShop: PetShop!
        if searchController.active && searchController.searchBar.text != "" {
            petShop = filteredPetShops[indexPath.row]
        } else {
            petShop = allPetShops[indexPath.row]
        }
        
        cell.petShopNameLabel.text = petShop.name
        cell.petShopAddressLabel.text = petShop.address
        cell.ranking = Int(petShop.ranking)
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredPetShops.count
        } else {
            return allPetShops.count
        }

    }
    
    @IBAction func filterButton(sender: AnyObject) {
    
    
    }
    
    func reloadPetShops () {
        PetShop.getNearbyPetShops(10, longitude: 10, withinKilometers: 10, response: { (petshops, error) in
            self.allPetShops = petshops!
            self.refreshControl.endRefreshing()
        })
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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

extension PetShopsViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterPetShopsForSearchText(searchController.searchBar.text!)
        
    }
}
