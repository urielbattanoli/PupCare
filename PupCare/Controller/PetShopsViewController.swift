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
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Voltar", style: .plain, target: nil, action: nil)
        
        if UserManager.sharedInstance.user == nil{
            UserManager.sharedInstance.createUserByCurrentUser()
        }
        
        petShopsTableView.dataSource = self
        petShopsTableView.delegate = self
        
        petShopsTableView.separatorStyle = .none
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Puxe para atualizar")
        refreshControl.addTarget(self, action: #selector(PetShopsViewController.reloadPetShops), for: UIControlEvents.valueChanged)
        
        petShopsTableView.addSubview(refreshControl)
        
        searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchBar.scopeButtonTitles = Array()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
//        petShopsTableView.tableHeaderView = searchController.searchBar
        
        searchController.hidesNavigationBarDuringPresentation = false
        
        self.reloadPetShops()
        
//        self.petShopsTableView.contentOffset = CGPointMake(0, self.petShopsTableView.tableHeaderView!.frame.size.height)//self.searchController.searchBar.frame.size.height)
        
    }
    
    func filterPetShopsForSearchText(_ searchText: String, scope: String = "All") {
        filteredPetShops = allPetShops.filter { petShop in
            return petShop.name.lowercased().contains(searchText.lowercased())
        }
        
        petShopsTableView.reloadData()
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetShopCell", for: indexPath) as! PetShopsTableViewCell
        
        let petShop: PetShop!
        if searchController.isActive && searchController.searchBar.text != "" {
            petShop = filteredPetShops[(indexPath as NSIndexPath).row]
        } else {
            petShop = allPetShops[(indexPath as NSIndexPath).row]
        }
        
        cell.petShopNameLabel.text = petShop.name
        cell.petShopAddressLabel.text = petShop.address
        cell.ranking = Int(petShop.ranking)
        cell.petShopImageView.loadImage(petShop.imageUrl)
        if let location = UserManager.sharedInstance.getLocationToSearch(){
            cell.petShopDistanceLabel.text = "\((petShop.location.distance(from: location)/1000).roundToPlaces(2)) km"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredPetShops.count
        } else {
            return allPetShops.count
        }
        
    }
    
    @IBAction func filterButton(_ sender: AnyObject) {
        
        
    }
    
    func reloadPetShops () {
        PetShopManager.sharedInstance.getNearPetShops(10, longitude: 10, withinKilometers: 10000, response: { (petshops, error) in
            if error == nil {
                self.allPetShops = petshops!
                // Descomentar quando arrumar cloud
                self.refreshControl.endRefreshing()
                self.petShopsTableView.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Products", sender:  self.allPetShops[(indexPath as NSIndexPath).row])
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Products" {
            let productsViewController = segue.destination as! ProductTableViewController
            
            productsViewController.petShop = sender as? PetShop
        }
    }
}

extension PetShopsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterPetShopsForSearchText(searchController.searchBar.text!)
        
    }
}
