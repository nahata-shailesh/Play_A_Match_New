//
//  TextInputTableViewCell.swift
//  My App
//
//  Created by Shailesh Nahata on 16/07/16.
//  Copyright © 2016 Shailesh Nahata. All rights reserved.
//

import UIKit

public class TextInputTableViewCell: UITableViewCell {
    
    @IBOutlet weak var TextField: UITextField!
    
    public func configure(text: String?, placeholder: String?) {
        TextField.text = text
        TextField.placeholder = placeholder 
    }
}
