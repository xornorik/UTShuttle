//
//  CountryPickerTextField.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 11/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit


class CountryPickerTextField: UITextField {
    
    
    let padding = UIEdgeInsets(top: 0, left: 55, bottom: 0, right: 1);
    
    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
