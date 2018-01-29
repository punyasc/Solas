//
//  PlacemarkDetailViewController.swift
//  Solas
//
//  Created by Punya Chatterjee on 12/1/17.
//  Copyright © 2017 Punya Chatterjee. All rights reserved.
//

import UIKit
import MapKit

class PlacemarkDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setMap()
    }
    
    var placemark:MKPlacemark? = nil
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBAction func openMapsPress(_ sender: Any) {
        let mapItem = MKMapItem(placemark: placemark!)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDefault]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
    
    func setMap() {
        /*
        let coord = CLLocationCoordinate2D(latitude: (chosenPOI?.location.coordinate?.latitude)!, longitude: (chosenPOI?.location.coordinate?.longitude)!)*/
        let coord = placemark?.coordinate
        //map.setCenter(coord, animated: true)
        let viewRegion = MKCoordinateRegionMakeWithDistance(coord!, 200, 200)
        mapView.setRegion(viewRegion, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coord!
        annotation.subtitle = placemark?.name
        mapView.addAnnotation(annotation)
        nameLabel.text = placemark?.name
        addressLabel.text = parseAddress(selectedItem: placemark!)
    }
    
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
