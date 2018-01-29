//
//  ExpandableCells.swift
//  Solas
//
//  Created by Punya Chatterjee on 11/29/17.
//  Copyright © 2017 Punya Chatterjee. All rights reserved.
//

import UIKit
import ExpandableCell


class NormalCell: UITableViewCell {
    static let ID = "NormalCell"
}

class ExpandableCell2: ExpandableCell {
    static let ID = "ExpandableCell"
    
}

class ExpandedCell: UITableViewCell {
    static let ID = "ExpandedCell"
    
    @IBOutlet var titleLabel: UILabel!
}
