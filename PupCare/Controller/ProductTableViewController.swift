//
//  ProductTableViewController.swift
//  PupCare
//
//  Created by Uriel Battanoli on 7/5/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class ProductTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate {
    
    // MARK: outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var petShopImage: UIImageView!
    @IBOutlet weak var petShopName: UILabel!
    @IBOutlet weak var petShopAdress: UILabel!
    @IBOutlet weak var petShopNeighbourhood: UILabel!
    @IBOutlet weak var petShopDistance: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var TableViewConstraint: NSLayoutConstraint!
    
    // MARK: Variables
    var petShop: PetShop?
    
    var products: [Product]?{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    var filteredProducts: [Product] = []
    var tap: UITapGestureRecognizer!
    
    
    var refreshControl: UIRefreshControl?{
        didSet{
            self.refreshControl?.attributedTitle = NSAttributedString(string: "Puxe para Atualizar")
            self.refreshControl?.addTarget(self, action: #selector(ProductTableViewController.reloadProducts), for: .valueChanged)
            self.tableView.addSubview(self.refreshControl!)
        }
    }
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        self.title = "Detalhes da Pet Shop"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Voltar", style: .plain, target: nil, action: nil)
        
        self.searchBar.delegate = self
        if let searchField = self.searchBar.value(forKey: "searchField") as? UITextField{
            searchField.backgroundColor = self.searchBar.backgroundColor
            searchField.textColor = UIColor.white
            self.searchBar.barTintColor = UIColor.white
            self.searchBar.backgroundColor = UIColor.white
            
            if let placeholder = searchField.value(forKey: "placeholderLabel") as? UILabel{
                placeholder.textColor = UIColor.white
            }
        }
        
        
        self.refreshControl = UIRefreshControl()
        self.tableView.tableFooterView = UIView()
        
        if let petShop = self.petShop{
            self.petShopName.text = petShop.name
            self.petShopAdress.text = petShop.address.street
            self.petShopImage.loadImage(petShop.imageUrl)
            self.petShopNeighbourhood.text = petShop.address.neighbourhood
            
            if let location = UserManager.sharedInstance.getLocationToSearch(){
                var distance = Float(petShop.address.location.distance(from: location))
                distance = distance / 1000
                
                self.petShopDistance.text = "\(distance.roundToPlaces(2)) km"
            }
            
            if petShop.products.count > 0{
                self.products = petShop.products
            }
            else{
                ProductManager.getProductList(petShop.objectId, block: { (products) in
                    petShop.products = products
                    self.products = products
                })
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        checkCart()
    }
    
    
    //MARK: Adjust Constraints
    func checkCart() {
        if Cart.sharedInstance.cartDict.petShopList.count > 0 { //.getTotalItemsAndPrice().0 > 0 {
            adjustConstraintsForCart()
        } else {
            adjustConstraintsToHideCart()
        }
    }
    
    func adjustConstraintsForCart() {
        self.TableViewConstraint.constant = 75
    }
    
    func adjustConstraintsToHideCart() {
        self.TableViewConstraint.constant = 0
    }
    
    // MARK: Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  !(self.searchBar.text?.isEmpty)! {
            return self.filteredProducts.count 
        }
        else{
            return self.products?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellProduct", for: indexPath) as! ProductTableViewCell
        let product: Product!
        if !(self.searchBar.text?.isEmpty)! {
            product = self.filteredProducts[(indexPath as NSIndexPath).row]
        } else {
            product = self.products![(indexPath as NSIndexPath).row]
        }
        cell.product = product
        cell.lblPrice.text = product.price.numberToPrice()
        
        return cell
    }
    
    // MARK: Table view delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetail", sender: self.products![(indexPath as NSIndexPath).row])
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // MARK: SearchBar delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterProductsForSearchText(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.filterProductsForSearchText("")
        self.view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        view.addGestureRecognizer(tap)
    }
    override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(tap)
    }
    
    // MARK: Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail"{
            let productDetail = segue.destination as! ProductDetailViewController
            
            productDetail.product = sender as? Product
            productDetail.petshop = self.petShop
        }
    }
    
    func filterProductsForSearchText(_ searchText: String, scope: String = "All") {
        self.filteredProducts = products!.filter { product in
            return product.name.lowercased().contains(searchText.lowercased())
        }
        
        self.tableView.reloadData()
        
        if searchText.isEmpty{
            searchBar.showsCancelButton = false
        }else{
            searchBar.showsCancelButton = true
        }
    }
    
    func reloadProducts() {
        ProductManager.getProductList((petShop?.objectId)!) { (products) in
            self.products = products
            self.refreshControl?.endRefreshing()
        }
    }
}

extension ProductTableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterProductsForSearchText(searchController.searchBar.text!)
    }
}
