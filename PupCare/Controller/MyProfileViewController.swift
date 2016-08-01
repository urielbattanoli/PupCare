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
    private let numberOfSections = 4
    private let numberOfRowSection0 = 1
    private let numberOfRowSection1 = 5
    private var numberOfRowSection2 = 3
    private let numberOfRowSectionShrunk = 2
    
    var section1Expanded = false
    var section2Expanded = false
    
    var user: User!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user = User(parseObject: PFUser.currentUser()!)
        print(self.user)
        self.tableView.delegate = self
        self.numberOfRowSection2 = self.user.cards.count+3
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
        self.numberOfRowSection2 = self.user.cards.count+3
        
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
            profile.photoUrl = user.photoUrl
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
            cell.string = self.user.name
            
        case 1 where indexPath.row == 2:
            cell.string = self.user.email
            
        case 1 where indexPath.row == 3:
            cell.string = "Graciano Azambuja, 229"
            cell.setCorner()
            
        case 1 where indexPath.row == 4:
            return separator
            
        case 2:
            if indexPath.row == 0{
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
            }
            if (!self.section2Expanded && indexPath.row == self.numberOfRowSectionShrunk-1) || indexPath.row == self.numberOfRowSection2-1{
                return separator
            }
            
            if self.section2Expanded{
                let cellCard = tableView.dequeueReusableCellWithIdentifier("cellCard") as! MyProfileCardTableViewCell
                
                if indexPath.row == self.numberOfRowSection2-2{
                    cellCard.setCorner()
                    return cellCard
                }
                cellCard.card = self.user.cards[indexPath.row-1]
            }
            
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
        switch indexPath.section {
        case 2:
            if indexPath.row == self.numberOfRowSection2-2{
                performSegueWithIdentifier("cardSegue", sender: nil)
            }
            else if indexPath.row>0 && indexPath.row<self.numberOfRowSection2-2{
                let card = self.user.cards[indexPath.row-1]
                performSegueWithIdentifier("cardSegue", sender: card)
            }
        default:
            print("default didSelect card")
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
    
    func cellCardTapped(obj: AnyObject) {
        
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
        case "cardSegue":
            let addCardVC = segue.destinationViewController as! AddCardViewController
            addCardVC.delegate = self
            if let card = sender as? Card{
                addCardVC.card = card
            }
        default:
            print("default prepareForSegue")
        }
    }
    
    //MARK: Card delegate
    func cardDidAdded(card: Card) {
        if !self.user.cards.contains(card){
            self.user.cards.append(card)
        }
        self.tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: .Automatic)
    }
}