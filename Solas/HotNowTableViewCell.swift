//
//  HotNowTableViewCell.swift
//  Solas
//
//  Created by Punya Chatterjee on 11/20/17.
//  Copyright © 2017 Punya Chatterjee. All rights reserved.
//

import UIKit

class HotNowTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var placeNameLabel: UILabel!
    @IBOutlet var tagLabel: UILabel!
    
    
    func update(poi:SolasPOI, tag: String) {
        backgroundImage.image = poi.thumbnail
        placeNameLabel.text = poi.name
        tagLabel.text = tag
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
