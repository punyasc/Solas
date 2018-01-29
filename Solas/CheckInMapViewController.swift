//
//  CheckInMapViewController.swift
//  Solas
//
//  Created by Punya Chatterjee on 12/1/17.
//  Copyright © 2017 Punya Chatterjee. All rights reserved.
//

import UIKit
import MapKit
import Toast_Swift

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}

class CheckInMapViewController: UIViewController {

    let locationManager = CLLocationManager()
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    var pinColor = UIColor(red:0.41, green:0.36, blue:0.96, alpha:1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        recenter(animated: true)
        addHeatmapOverlay()
        
        // Do any additional setup after loading the view.
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "CheckInSearchTableViewController") as! CheckInSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Type In Your Current Location"
        navigationItem.searchController = resultSearchController
        //navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        self.confirmView.alpha = 0.0
        //confirmView.isHidden = true
        
        let titleImageView = NavigationImageView()
        titleImageView.image = #imageLiteral(resourceName: "SolasLogoWeb")
        navigationItem.titleView = titleImageView
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //locationManager.requestLocation()
        //confirmView.isHidden = true
        //confirmView.alpha = 0.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var confirmView: UIView!
    @IBAction func curLocPress(_ sender: Any) {
        //locationManager.location
        let mp = MKPlacemark(coordinate: locationManager.location!.coordinate)
        pinColor = self.view.tintColor
        dropPinZoomIn(placemark: mp)
    }
    
    @IBAction func checkInPress(_ sender: Any) {
        let nav = tabBarController?.viewControllers![0] as! UINavigationController
        let home = nav.topViewController as! HomeViewController
        home.lastCheckin = selectedPin
        mapView.removeAnnotations(mapView.annotations)
        confirmView.alpha = 0.0
        recenter(animated: false)
        resultSearchController?.searchBar.text = ""
        tabBarController?.selectedIndex = 0
    }
    
    func recenter(animated: Bool) {
        var location = locationManager.location ?? CLLocation(latitude: 37.42410599999999, longitude: -122.1660756)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: animated)
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
extension CheckInMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Got Location!")
            /*
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)*/
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
    
}

extension CheckInMapViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city), \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
        //confirmView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.confirmView.alpha = 0.8
        })
        print("TOAST")
        let toastPoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2 - 50)
        if let name = placemark.name {
            print("A")
           
           self.view.makeToast(name, duration: 1.0, position: toastPoint)
        } else {
            print("B")
            self.view.makeToast("Current Location", duration: 1.0, position: toastPoint)
        }
        
        //confirmView.alpha = 1.0
    }
    
    func addHeatmapOverlay() {
        var overlayBoundingMapRect: MKMapRect {
            get {
                let tlc = CLLocationCoordinate2D(latitude: 37.7597, longitude: -122.6194)
                let topLeft = MKMapPointForCoordinate(tlc)
                let trc = CLLocationCoordinate2D(latitude: 37.7597, longitude: -121.7178)
                let topRight = MKMapPointForCoordinate(trc)
                let blc = CLLocationCoordinate2D(latitude: 37.0407, longitude: -122.6194)
                let bottomLeft = MKMapPointForCoordinate(blc)
                
                return MKMapRectMake(
                    topLeft.x,
                    topLeft.y,
                    fabs(topLeft.x - topRight.x),
                    fabs(topLeft.y - bottomLeft.y))
            }
        }
        
        let center = CLLocationCoordinate2D(latitude: 37.4196458, longitude: -122.1739068)
        let overlay = HeatMapOverlay(center: center, bound: overlayBoundingMapRect)
        mapView.add(overlay)
    }
    
    
}

extension CheckInMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is HeatMapOverlay {
            print("HEATMAP")
            return HeatMapOverlayRenderer(overlay: overlay, overlayImage: #imageLiteral(resourceName: "bay3000"))
        }
        print("NO HEATMAP")
        return MKOverlayRenderer()
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        if annotation is MKUserLocation {
            return nil
        } else {
            return mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        }
        
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = pinColor
        pinView?.canShowCallout = true
        pinColor = UIColor(red:0.41, green:0.36, blue:0.96, alpha:1.0)
        /*
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(type: .infoLight)
        button.addTarget(self, action: "viewLocationInfo", for: .touchUpInside)
        pinView?.rightCalloutAccessoryView = button
         */
        return pinView
    }
    
    @objc func viewLocationInfo() {
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            performSegue(withIdentifier: "PlacemarkDetailShow", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dest = segue.destination as? PlacemarkDetailViewController else { return }
        dest.placemark = selectedPin
    }
    
}


