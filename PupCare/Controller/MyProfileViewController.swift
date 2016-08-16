//
//  MyProfileViewController.swift
//  PupCare
//
//  Created by Uriel Battanoli on 7/11/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import Parse

//Mark: Add card protocol

class MyProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddCardDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variables
    private let numberOfSections = 3
    private let numberOfRowSection0 = 1
    private let numberOfRowSection1 = 5
    private var numberOfRowSection2 = 1
    private let numberOfRowSectionShrunk = 2
    
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
        
        self.user = User(parseObject: PFUser.currentUser()!)
        
        self.tableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table View Data Source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.numberOfSections
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let separator = tableView.dequeueReusableCellWithIdentifier("cellSeparator")!
        let cell = tableView.dequeueReusableCellWithIdentifier("cellProfileDetail") as! MyProfileDetailTableViewCell
        let section = tableView.dequeueReusableCellWithIdentifier("cellProfileSection") as! MyProfileDetailTableViewCell
        
        switch indexPath.section {
        case 0:
            let profile = tableView.dequeueReusableCellWithIdentifier("cellProfile") as! MyProfileTableViewCell
            profile.photoUrl = user.photoUrl
            self.imageProfile = profile.imageProfile
            return profile
            
        case 1 where indexPath.row == 0:
            section.string = "Dados Pessoais"
            
            if !self.section1Expanded{
                section.changeConstraintSize(0)
            }
            else{
                section.changeConstraintSize(-15)
            }
            section.setCorner()
            return section
            
        case 1 where indexPath.row == 1:
            if !self.section1Expanded{
                return separator
            }
            cell.string = self.user.name
            
        case 1 where indexPath.row == 2:
            cell.string = self.user.email
            
        case 1 where indexPath.row > 2 && indexPath.row < self.numberOfRowSection1-1:
            let addressCell = tableView.dequeueReusableCellWithIdentifier("cellAddress") as! MyProfileAddressTableViewCell
            if indexPath.row == self.numberOfRowSection1-2{
                addressCell.setCorner()
                return addressCell
            }
            addressCell.address = self.user.addressList[indexPath.row-3]
            return addressCell
            
        case 1 where indexPath.row == self.numberOfRowSection1-1:
            return separator
            
        case 2 where indexPath.row == 0:
            let logOut = tableView.dequeueReusableCellWithIdentifier("cellLogOut") as! MyProfileDetailTableViewCell
            logOut.string = "Sair"
            logOut.setCorner()
            
            return logOut
        case 2 where indexPath.row == 1:
            return separator
            
        default:
            print("default section in cell for row")
        }
        
        return cell
    }
    
    // MARK: Table View Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section {
        case 1 where indexPath.row == 0:
            self.section1Expanded = !self.section1Expanded
            self.tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
        case 1 where indexPath.row > 2 && indexPath.row < self.numberOfRowSection1-1:
            if indexPath.row == self.numberOfRowSection1-2{
                performSegueWithIdentifier("goToAddAddress", sender: nil)
                return
            }
            let address = self.user.addressList[indexPath.row-2]
            performSegueWithIdentifier("goToAddAddress", sender: address)
        case 2:
            self.didPressLogOut()
        default:
            print("default didSelect")
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 255
        }
        else if indexPath.row == 0{
            return 45
        }
        else if (indexPath.section == 1 && indexPath.row == numberOfRowSection1-1)||(indexPath.section == 2 && indexPath.row == self.numberOfRowSection2-1) || (!self.section1Expanded && indexPath.section == 1) || (!self.section2Expanded && indexPath.section == 2){
            return 20
        }
        return 40
    }
    
    // MARK: Functions
    func didPressPhoto(obj: AnyObject) {
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Voltar", style: .Plain, target: nil, action: nil)
        
        switch segue.identifier! {
        case "logInSegue":
            segue.destinationViewController.childViewControllers[0] as! LoginViewController
        default:
            print("default prepareForSegue")
        }
    }
}