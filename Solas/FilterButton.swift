//
//  FilterButton.swift
//  Solas
//
//  Created by Punya Chatterjee on 12/5/17.
//  Copyright © 2017 Punya Chatterjee. All rights reserved.
//

import UIKit

@IBDesignable class FilterButton: UIButton
{
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }
}
