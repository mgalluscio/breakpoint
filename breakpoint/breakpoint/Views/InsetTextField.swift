//
//  InsetTextField.swift
//  breakpoint
//
//  Created by Mario Galluscio on 1/30/19.
//  Copyright © 2019 Mario Galluscio. All rights reserved.
//

import UIKit

class InsetTextField: UITextField {
    // what it should look like itself, placeholder has left padding of 20
    private var padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    
    // makes placeholder white, will be called from awakeFromNib
    override func awakeFromNib() {
        let placeholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)])
        
        self.attributedPlaceholder = placeholder
        super.awakeFromNib()
    }
    
    // where the text is held
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    // where the text is being edited
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    // where the placeholder is
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
