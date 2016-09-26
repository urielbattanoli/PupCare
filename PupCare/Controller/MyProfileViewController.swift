//
//  MyProfileViewController.swift
//  PupCare
//
//  Created by Uriel Battanoli on 7/11/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import Parse

class MyProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddAddressDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variables
    fileprivate let numberOfSections = 3
    fileprivate let numberOfRowSection0 = 1
    fileprivate var numberOfRowSection1 = 5
    fileprivate let numberOfRowSection2 = 1
    fileprivate let numberOfRowSectionShrunk = 2
    
    var section1Expanded = false
    var section2Expanded = false
    
    var user: User!
    var imageProfile: UIImageView?{
        didSet{
            let gest = UITapGestureRecognizer(target: self, action: #selector(self.didPressPhoto))
            self.imageProfile!.addGestureRecognizer(gest)
        }
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserManager.sharedInstance.user == nil{
            UserManager.sharedInstance.createUserByCurrentUser()
        }
        self.user = UserManager.sharedInstance.user

        self.tableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table View Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.numberOfRowSection1 = self.user.addressList.count + 5
        
        switch section {
        case 0:
            return self.numberOfRowSection0
        case 1 where self.section1Expanded:
            return self.numberOfRowSection1
        case 2 where self.section2Expanded:
            return self.numberOfRowSection2
        default:
            print("default section\(section)")
        }
        return self.numberOfRowSectionShrunk
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let separator = tableView.dequeueReusableCell(withIdentifier: "cellSeparator")!
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellProfileDetail") as! MyProfileDetailTableViewCell
        let section = tableView.dequeueReusableCell(withIdentifier: "cellProfileSection") as! MyProfileDetailTableViewCell
        
        switch (indexPath as NSIndexPath).section {
        case 0:
            let profile = tableView.dequeueReusableCell(withIdentifier: "cellProfile") as! MyProfileTableViewCell
            profile.photoUrl = user.photoUrl
            self.imageProfile = profile.imageProfile
            return profile
            
        case 1 where (indexPath as NSIndexPath).row == 0:
            section.string = "Dados Pessoais"
            
            if !self.section1Expanded{
                section.changeConstraintSize(0)
            }
            else{
                section.changeConstraintSize(-15)
            }
            section.setCorner()
            return section
            
        case 1 where (indexPath as NSIndexPath).row == 1:
            if !self.section1Expanded{
                return separator
            }
            cell.string = self.user.name
            
        case 1 where (indexPath as NSIndexPath).row == 2:
            cell.string = self.user.email
            
        case 1 where (indexPath as NSIndexPath).row > 2 && (indexPath as NSIndexPath).row < self.numberOfRowSection1-1:
            let addressCell = tableView.dequeueReusableCell(withIdentifier: "cellAddress") as! MyProfileAddressTableViewCell
            if (indexPath as NSIndexPath).row == self.numberOfRowSection1-2{
                addressCell.setCorner()
                addressCell.imageAddress.image = UIImage(named: "moreBt")
                return addressCell
            }
            addressCell.imageAddress = nil
            addressCell.address = self.user.addressList[(indexPath as NSIndexPath).row-3]
            return addressCell
            
        case 1 where (indexPath as NSIndexPath).row == self.numberOfRowSection1-1:
            return separator
            
        case 2 where (indexPath as NSIndexPath).row == 0:
            let logOut = tableView.dequeueReusableCell(withIdentifier: "cellLogOut") as! MyProfileDetailTableViewCell
            logOut.string = "Sair"
            logOut.setCorner()
            
            return logOut
        case 2 where (indexPath as NSIndexPath).row == 1:
            return separator
            
        default:
            print("default section in cell for row")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath as NSIndexPath).section == 1{
            if (indexPath as NSIndexPath).row > 2 && (indexPath as NSIndexPath).row < self.numberOfRowSection1-2{
                return true
            }
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            if (indexPath as NSIndexPath).section == 1{
                let address = self.user.addressList[(indexPath as NSIndexPath).row-3]
                AddressManager.sharedInstance.removeAddressFromParse(address)
                self.user.addressList.remove(at: (indexPath as NSIndexPath).row-3)
                self.numberOfRowSection1 -= 1
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            print("default commitEditing")
        }
    }
    
    // MARK: Table View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath as NSIndexPath).section {
        case 1 where (indexPath as NSIndexPath).row == 0:
            self.section1Expanded = !self.section1Expanded
            self.tableView.reloadSections(IndexSet(integer: (indexPath as NSIndexPath).section), with: .fade)
        case 1 where (indexPath as NSIndexPath).row > 2 && (indexPath as NSIndexPath).row < self.numberOfRowSection1-1:
            if (indexPath as NSIndexPath).row == self.numberOfRowSection1-2{
                performSegue(withIdentifier: "goToAddAddress", sender: nil)
                return
            }
            let address = self.user.addressList[(indexPath as NSIndexPath).row-3]
            performSegue(withIdentifier: "goToAddAddress", sender: address)
        case 2:
            self.didPressLogOut()
        default:
            print("default didSelect")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 0{
            return 255
        }
        else if (indexPath as NSIndexPath).row == 0{
            return 45
        }
        else if ((indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == numberOfRowSection1-1)||((indexPath as NSIndexPath).section == 2 && (indexPath as NSIndexPath).row == self.numberOfRowSection2-1) || (!self.section1Expanded && (indexPath as NSIndexPath).section == 1) || (!self.section2Expanded && (indexPath as NSIndexPath).section == 2){
            return 20
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteBt = UITableViewRowAction(style: .default, title: "Remover") { (acton, indexPath) in
            self.tableView.dataSource?.tableView!(
                self.tableView,
                commit: .delete,
                forRowAt: indexPath)
            return
        }
        deleteBt.backgroundColor = UIColor(red: 165, green: 22, blue: 25)
        return [deleteBt]
    }
    
    // MARK: Functions
    func didPressPhoto(_ obj: AnyObject) {
        print(obj)
    }
    
    func didPressLogOut() {
        UserManager.sharedInstance.logOutUser {
            let vcProfile : UIViewController! = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
            vcProfile.tabBarItem = UITabBarItem(title: "Minha Conta", image: UIImage(named: "userIcon"), selectedImage: nil)
            
            var viewControllers = self.tabBarController?.viewControllers ?? []
            viewControllers[3] = vcProfile
            
            self.tabBarController?.setViewControllers(viewControllers, animated: false)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "logInSegue":
            segue.destination.childViewControllers[0] as! LoginViewController
        case "goToAddAddress":
            let addressVC = segue.destination as! AddressViewController
            addressVC.delegate = self
            if let address = sender as? Address{
                addressVC.address = address
            }
        default:
            print("default prepareForSegue")
        }
    }
    
    // MARK: Address delegate
    func addressAdded(_ address: Address){
        if !self.user.addressList.contains(address){
            self.user.addressList.append(address)
        }
        self.tableView.reloadSections(IndexSet(integer: 1), with: .fade)
    }
}
