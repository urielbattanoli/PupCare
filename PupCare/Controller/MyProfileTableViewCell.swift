//
//  MyProfileTableViewCell.swift
//  PupCare
//
//  Created by Uriel Battanoli on 7/12/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class MyProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var imageProfile: UIImageView!
    
    var photoUrl: String?{
        didSet{
            if let url = self.photoUrl{
                self.imageProfile.loadImage(url)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
