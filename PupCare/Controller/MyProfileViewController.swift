//
//  MyProfileViewController.swift
//  PupCare
//
//  Created by Uriel Battanoli on 7/11/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variables
    private let numberOfSections = 4
    private let numberOfRowSection0 = 1
    private let numberOfRowSection1 = 5
    private let numberOfRowSection2 = 5
    private let numberOfRowSectionShrunk = 2
    
    var section1Expanded = false
    var section2Expanded = false
    
    var user: User?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        case 3:
            return 1
        default:
            print("default section")
        }
        return self.numberOfRowSectionShrunk
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let logOut = tableView.dequeueReusableCellWithIdentifier("cellLogOut") as! MyProfileDetailTableViewCell
        let separator = tableView.dequeueReusableCellWithIdentifier("cellSeparator")!
        let cell = tableView.dequeueReusableCellWithIdentifier("cellProfileDetail") as! MyProfileDetailTableViewCell
        let section = tableView.dequeueReusableCellWithIdentifier("cellProfileSection") as! MyProfileDetailTableViewCell
        
        switch indexPath.section {
        case 0:
            let profile = tableView.dequeueReusableCellWithIdentifier("cellProfile") as! MyProfileTableViewCell
            profile.photoUrl = "https://fbcdn-sphotos-a-a.akamaihd.net/hphotos-ak-xap1/v/t1.0-9/22729_821076457975277_2327804208051810931_n.jpg?oh=177f81efd8e3384b1ac1a01ca9266994&oe=57F6ECBC&__gda__=1478920913_017f3319e64c909d609126b6811800bb"//user?.photoUrl
            return profile
            
        case 1 where indexPath.row == 0:
            section.string = "Dados Pessoais"
            section.contentView.tag = indexPath.section
            
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyProfileViewController.sectionTapped(_:)))
            
            section.contentView.addGestureRecognizer(gestureRecognizer)
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
            cell.string = "Uriel Battanoli"//user?.name
            
        case 1 where indexPath.row == 2:
            cell.string = "001.094.302-12"
            
        case 1 where indexPath.row == 3:
            cell.string = "Graciano Azambuja, 229"
            cell.setCorner()
            
        case 1 where indexPath.row == 4:
            return separator
            
        case 2 where indexPath.row == 0:
            section.string = "Dados do Cartão"
            section.contentView.tag = indexPath.section
            
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyProfileViewController.sectionTapped(_:)))
            
            section.contentView.addGestureRecognizer(gestureRecognizer)
            if !self.section2Expanded{
                section.changeConstraintSize(0)
            }
            else{
                section.changeConstraintSize(-15)
            }
            section.setCorner()
            return section
            
        case 2 where indexPath.row == 1:
            if !self.section2Expanded{
                return separator
            }
            cell.string = "**** **** **** 1234"
            
        case 2 where indexPath.row == 2:
            cell.string = "07/17"
            
        case 2 where indexPath.row == 3:
            cell.string = "***"
            cell.setCorner()
            
        case 2 where indexPath.row == 4:
            return separator
            
        case 3 where indexPath.row == 0:
            logOut.string = "Sair"
            logOut.setCorner()
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(MyProfileViewController.didPressLogOut))
            logOut.contentView.addGestureRecognizer(gesture)
            
            return logOut
        default:
            print("default section in cell for row")
        }
        
        return cell
    }
    
    // MARK: Table View Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 255
        }
        else if indexPath.row == 0{
            return 45
        }
        else if (indexPath.row == 4) || (!self.section1Expanded && indexPath.section == 1) || (!self.section2Expanded && indexPath.section == 2){
            return 20
        }
        return 40
    }
    
    // MARK: Functions
    func sectionTapped(obj: AnyObject) {
        let section = (obj as? UITapGestureRecognizer)?.view?.tag
        if section == 1 {
            self.section1Expanded = !self.section1Expanded
        }
        else if section == 2{
            self.section2Expanded = !self.section2Expanded
        }
        
        self.tableView.reloadSections(NSIndexSet(index: section!), withRowAnimation: .Automatic)
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
        if segue.identifier == "logInSegue" {
            segue.destinationViewController.childViewControllers[0] as! LoginViewController
        }
    }
}