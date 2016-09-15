//
//  CustomTableViewCell.swift
//  PupCare
//
//  Created by Uriel Battanoli on 9/5/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var firstLbl: UILabel!
    @IBOutlet weak var secondLbl: UILabel!
    
    @IBOutlet weak var finisheBt: BTNAttributedStyle!
    @IBOutlet weak var loaderBt: UIActivityIndicatorView!
    
    @IBOutlet weak var markSelected: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if self.markSelected != nil{
            self.markSelected.layer.cornerRadius = self.markSelected.frame.width/2
            self.markSelected.layer.borderWidth = 0.5
            self.markSelected.layer.borderColor = UIColor(red: 145, green: 145, blue: 145).cgColor
            self.markSelected.backgroundColor = UIColor(red: 245, green: 245, blue: 245)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func selectAddress() {
        if self.markSelected != nil {
            self.markSelected.backgroundColor = UIColor(red: 115, green: 40, blue: 115)
        }
    }
    
    func deselectAddress() {
        if self.markSelected != nil {
            self.markSelected.backgroundColor = UIColor(red: 245, green: 245, blue: 245)
        }
    }
}
