//
//  UpdateEventTableViewCell.swift
//  My App
//
//  Created by Shailesh Nahata on 22/08/16.
//  Copyright © 2016 Shailesh Nahata. All rights reserved.
//

import UIKit

class UpdateEventTableViewCell: UITableViewCell {

    @IBOutlet weak var myTextField: UITextField!
    
    internal func configure(text: String?, placeholder: String?) {
        myTextField.text = text
        myTextField.placeholder = placeholder
    }

   
}
