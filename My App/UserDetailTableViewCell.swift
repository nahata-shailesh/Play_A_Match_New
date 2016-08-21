//
//  UserDetailTableViewCell.swift
//  My App
//
//  Created by Shailesh Nahata on 21/08/16.
//  Copyright © 2016 Shailesh Nahata. All rights reserved.
//

import UIKit

class UserDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var myTextLabel: UILabel!
    
    func configure(text: String?) {
        myTextLabel.text = text
    }

}
