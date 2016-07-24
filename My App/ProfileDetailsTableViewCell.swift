//
//  ProfileDetailsTableViewCell.swift
//  My App
//
//  Created by Shailesh Nahata on 20/07/16.
//  Copyright © 2016 Shailesh Nahata. All rights reserved.
//

import UIKit

class ProfileDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var myTextLabel: UILabel!
    
    func configure(text: String?) {
        myTextLabel.text = text
    }
}
