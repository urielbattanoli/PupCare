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
        CardManager.sharedInstance.getCardList(user.userId!) { (cards) in
            self.user.cards = cards
            self.tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: .Automatic)
        }
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
                return cellCard
            }
            
        case 3 where indexPath.row == 0:
            let logOut = tableView.dequeueReusableCellWithIdentifier("cellLogOut") as! MyProfileDetailTableViewCell
            logOut.string = "Sair"
            logOut.setCorner()
            
            return logOut
        default:
            print("default section in cell for row")
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            if indexPath.section == 2{
                let row = indexPath.row
                if row>0 && row<self.numberOfRowSection2-2{
                    self.user.cards.removeAtIndex(row-1)
                    self.numberOfRowSection2 -= 1
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
            }
        default:
            print("default commitEditing")
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 2{
            if indexPath.row>0 && indexPath.row<self.numberOfRowSection2-2{
                return true
            }
        }
        return false
    }
    
    // MARK: Table View Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section {
        case 1:
            if indexPath.row == 0{
                self.section1Expanded = !self.section1Expanded
                self.tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
            }
        case 2:
            if indexPath.row == 0{
                self.section2Expanded = !self.section2Expanded
                self.tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
            }
            if indexPath.row == self.numberOfRowSection2-2{
                performSegueWithIdentifier("cardSegue", sender: nil)
            }
            else if indexPath.row>0 && indexPath.row<self.numberOfRowSection2-2{
                let card = self.user.cards[indexPath.row-1]
                performSegueWithIdentifier("cardSegue", sender: card)
            }
        case 3:
            if indexPath.row == 0{
                self.didPressLogOut()
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
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteBt = UITableViewRowAction(style: .Default, title: "Remover") { (action, indexPath) in
            self.tableView.dataSource?.tableView!(
                self.tableView,
                commitEditingStyle: .Delete,
                forRowAtIndexPath: indexPath)
            return
        }
        deleteBt.backgroundColor = UIColor(red: 165/255, green: 22/255, blue: 25/255, alpha: 1)
        return [deleteBt]
    }
    
    // MARK: Functions
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