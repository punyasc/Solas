//
//  SolasPOI.swift
//  Solas
//
//  Created by Punya Chatterjee on 11/20/17.
//  Copyright © 2017 Punya Chatterjee. All rights reserved.
//

import Foundation
import UIKit
import YelpAPI

struct SolasPOI {
    var name: String
    var thumbnail: UIImage
    var solasRank: Float
    var location: YLPLocation
    var yelpID: String
    var rating: Double
    var numRatings: UInt
    var tags: [String]
}
