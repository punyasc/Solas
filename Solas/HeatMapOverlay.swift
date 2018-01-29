//
//  HeatMapOverlay.swift
//  Solas
//
//  Created by Punya Chatterjee on 12/5/17.
//  Copyright © 2017 Punya Chatterjee. All rights reserved.
//

import UIKit
import MapKit

class HeatMapOverlay: NSObject, MKOverlay {
    var coordinate: CLLocationCoordinate2D
    var boundingMapRect: MKMapRect
    
    init(center: CLLocationCoordinate2D, bound: MKMapRect) {
        boundingMapRect = bound
        coordinate = center
    }
}
