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
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variables
    var header0Expanded = false
    var header1Expanded = false
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Functions
    
    // MARK: Table View Data Source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0 where self.header0Expanded:
                return 3
        case 1 where self.header1Expanded:
                return 3
        default:
            print("default section")
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                return tableView.dequeueReusableCellWithIdentifier("")!
            case 1:
                return tableView.dequeueReusableCellWithIdentifier("")!
            case 2:
                return tableView.dequeueReusableCellWithIdentifier("")!
            default:
                print("default cellForRow InSection 0")
            }
        case 1:
            switch indexPath.row
            {
            case 0:
                return tableView.dequeueReusableCellWithIdentifier("")!
            case 1:
                return tableView.dequeueReusableCellWithIdentifier("")!
            case 2:
                return tableView.dequeueReusableCellWithIdentifier("")!
            default:
                print("default cellForRow InSection 1")
            }
        default:
            print("default section in cell for row")
        }
        
        return tableView.dequeueReusableCellWithIdentifier("")!
    }
    
    // MARK: Table View Delegate
}