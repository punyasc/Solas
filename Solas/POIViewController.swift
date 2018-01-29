//
//  POIViewController.swift
//  Solas
//
//  Created by Punya Chatterjee on 11/20/17.
//  Copyright © 2017 Punya Chatterjee. All rights reserved.
//

import UIKit
import MapKit
import YelpAPI
import Cosmos

@IBDesignable extension UIView {
    
    /* The color of the shadow. Defaults to opaque black. Colors created
     * from patterns are currently NOT supported. Animatable. */
    @IBInspectable var shadowColor: UIColor? {
        set {
            layer.shadowColor = newValue!.cgColor
        }
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            else {
                return nil
            }
        }
    }
    
    /* The opacity of the shadow. Defaults to 0. Specifying a value outside the
     * [0,1] range will give undefined results. Animatable. */
    @IBInspectable var shadowOpacity: Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }
    
    /* The shadow offset. Defaults to (0, -3). Animatable. */
    @IBInspectable var shadowOffset: CGPoint {
        set {
            layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
        }
        get {
            return CGPoint(x: layer.shadowOffset.width, y:layer.shadowOffset.height)
        }
    }
    
    /* The blur radius used to create the shadow. Defaults to 3. Animatable. */
    @IBInspectable var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }
}

class POIViewController: UIViewController {
    
    @IBOutlet var starRating: CosmosView!
    var chosenPOI:SolasPOI?
    var chosenTag:String?
    @IBOutlet var tag1: UIButton!
    @IBOutlet var tag2: UIButton!
    @IBOutlet var tag3: UIButton!
    @IBOutlet var taglineLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let coord = CLLocationCoordinate2D(latitude: (chosenPOI?.location.coordinate?.latitude)!, longitude: (chosenPOI?.location.coordinate?.longitude)!)
        //map.setCenter(coord, animated: true)
        let viewRegion = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
        map.setRegion(viewRegion, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coord
        annotation.subtitle = chosenPOI?.name
        map.addAnnotation(annotation)
        let num = Float((chosenPOI?.rating)!)
        print((chosenPOI?.rating)!/5.0)
        starRating.rating = Double(num)
        ratingLabel.text = "\(chosenPOI?.numRatings ?? 0) Ratings on Yelp"
        if let numTags = chosenPOI?.tags.count {
            switch numTags {
            case 1:
                tag1.setTitle(chosenPOI?.tags[0], for: .normal)
                tag2.isHidden = true
                tag3.isHidden = true
            case 2:
                tag1.setTitle(chosenPOI?.tags[0], for: .normal)
                tag2.setTitle(chosenPOI?.tags[1], for: .normal)
                tag3.isHidden = true
            case 3:
                tag1.setTitle(chosenPOI?.tags[0], for: .normal)
                tag2.setTitle(chosenPOI?.tags[1], for: .normal)
                tag3.setTitle(chosenPOI?.tags[2], for: .normal)
            default:
                tag1.isHidden = true
                tag2.isHidden = true
                tag3.isHidden = true
            }
        } else {
            tag1.isHidden = true
            tag2.isHidden = true
            tag3.isHidden = true
        }
        
        taglineLabel.text = chosenTag ?? ""
        
        // Do any additional setup after loading the view.
    }
    

    @IBOutlet var map: MKMapView!
    @IBOutlet var progress: UIProgressView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
