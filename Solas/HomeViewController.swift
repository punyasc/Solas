//
//  HomeViewController.swift
//  Solas
//
//  Created by Punya Chatterjee on 12/1/17.
//  Copyright © 2017 Punya Chatterjee. All rights reserved.
//

import UIKit
import MapKit
import Toast_Swift
import DTMHeatmap
import Fakery


class HomeViewController: UIViewController, MKMapViewDelegate {
    
    
    var heatmap:DTMHeatmap?
    var locationManager = CLLocationManager()
    var origin:CLLocation?
    var testpointCoor = [CLLocationCoordinate2D(latitude: 27, longitude: 120),CLLocationCoordinate2D(latitude: 25.3, longitude: 119),CLLocationCoordinate2D(latitude: 27, longitude: 120),
                         CLLocationCoordinate2D(latitude: 27, longitude: 121)
    ]
    var showFriends = false
    var friendPins:[MKAnnotation] = []
    var checkinPins:[MKAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        origin = CLLocation(latitude: 37.42410599999999, longitude: -122.1660756)
        lastCheckinView.alpha = 0.0
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        centerToUser()
        generateFakeFriends()
       
        
        let titleImageView = NavigationImageView()
        titleImageView.image = #imageLiteral(resourceName: "SolasLogoWeb")
        navigationItem.titleView = titleImageView
        
        
        //self.heatmap = DTMHeatmap()
        //heat.setData(parseLatLonFile("mcdonalds"))
        //self.mapView.add(self.heatmap!)
        print("OV:", mapView.overlays)
        addHeatmapOverlay()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLastCheckin()
    }
    
    @IBOutlet var lastCheckinLabel: UILabel!
    @IBOutlet var lastCheckinView: UIView!
    @IBOutlet var mapView: MKMapView!
    var placemarkSet = false
    var lastCheckin:MKPlacemark? = nil
    var allCheckin:[MKPlacemark] = []
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func removeLastCheckin() {
        /*
        if let last = mapView.annotations.last {
            if last is MKUserLocation {
                
            } else {
                mapView.removeAnnotation(last)
            }
        }
        
        for annotation in mapView.annotations {
            if let lastCheckinName = lastCheckin?.name, let sub = annotation.subtitle {
                if let sub = annotation.subtitle {
                    if lastCheckinName == sub {
                        mapView.removeAnnotation(annotation)
                    }
                }
            }
        }*/
        for annotation in checkinPins {
            mapView.removeAnnotation(annotation)
        }
    }
    
    @IBAction func checkOutPress(_ sender: Any) {
        removeLastCheckin()
        //mapView.removeAnnotations(mapView.annotations)
        //lastCheckinView.isHidden = true
        lastCheckin = nil
        UIView.animate(withDuration: 0.5, animations: {
            self.lastCheckinView.alpha = 0.0
        })
    }
    
    @IBAction func curLocPress(_ sender: Any) {
        print("CURLOC")
        locationManager.requestLocation()
        guard let origin = origin else { return }
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: origin.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        //setupHeatmaps()
        //centerToUser()
    }
    
    
    @IBAction func toggleFriendsPress(_ sender: UIButton) {
        showFriends = !showFriends
        if showFriends {
            sender.setImage(#imageLiteral(resourceName: "getFriendsInvertedButton"), for: .normal)
            mapView.showAnnotations(mapView.annotations, animated: true)
        } else {
            sender.setImage(#imageLiteral(resourceName: "getFriendsButton"), for: .normal)
        }
        
        for annotation in self.mapView.annotations {
            if annotation is MKUserLocation {
                continue
            }
            if let lastCheckinName = lastCheckin?.name, let sub = annotation.subtitle {
                if let sub = annotation.subtitle {
                    if lastCheckinName == sub {
                        continue
                    }
                }
                
            }
            self.mapView.view(for: annotation)?.isHidden = !showFriends
        }
        
        
        print("TOGGLE")
    }
    
    
    func centerToUser() {
        locationManager.requestLocation()
        if let location = locationManager.location {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        } 
        
    }
    
    func setLastCheckin() {
        removeLastCheckin()
        //mapView.removeAnnotations(mapView.annotations)
        guard let lastCheckin = lastCheckin else { return }
        //allCheckin.append(lastCheckin)
        let coord = lastCheckin.coordinate
        //map.setCenter(coord, animated: true)
        let viewRegion = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
        //mapView.setRegion(viewRegion, animated: true)
        mapView.setCenter(coord, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coord
        annotation.title = "Last Check-In"
        annotation.subtitle = lastCheckin.name
        checkinPins.append(annotation)
        mapView.addAnnotation(annotation)
        
        if let name = lastCheckin.name {
            lastCheckinLabel.text = "Checked-In: " + name
        } else {
            lastCheckinLabel.text = "Checked-In: Current Location"
        }
        //lastCheckinView.isHidden = false
        self.lastCheckinView.alpha = 0.8
        let toastPoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2 - 50)
        self.view.makeToast("Checked In!", duration: 1.0, position: toastPoint)
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
    /*
    var fakeFriends:[CLLocationCoordinate2D(latitude: 37.4390, longitude: -122.1583),
    CLLocationCoordinate2D(latitude: 37.4609, longitude: -122.1388),
    CLLocationCoordinate2D(latitude: 37.4842, longitude: -122.2300),
    CLLocationCoordinate2D(latitude: 37.4927, longitude: -122.2286),
    CLLocationCoordinate2D(latitude: 37.5488, longitude: -122.3101),
    CLLocationCoordinate2D(latitude: 37.7800, longitude: -122.4039),
    CLLocationCoordinate2D(latitude: 37.7871, longitude: -122.4057),
    CLLocationCoordinate2D(latitude: 37.8018, longitude: -122.4118),
    CLLocationCoordinate2D(latitude: 37.8055, longitude: -122.4233),
    CLLocationCoordinate2D(latitude: 37.7988, longitude: -122.4295),
    CLLocationCoordinate2D(latitude: 37.7605, longitude: -122.4686),
    CLLocationCoordinate2D(latitude: 37.7735, longitude: -122.4220),
    CLLocationCoordinate2D(latitude: 37.7735, longitude: -122.4221),
    CLLocationCoordinate2D(latitude: 37.3920, longitude: -122.0802),
    CLLocationCoordinate2D(latitude: 37.3895, longitude: -122.1101),
    CLLocationCoordinate2D(latitude: 37.3739, longitude: -122.1210),
    CLLocationCoordinate2D(latitude: 37.4636, longitude: -122.4286),
    CLLocationCoordinate2D(latitude: 37.7857, longitude: -122.4011),
    CLLocationCoordinate2D(latitude: 37.4306, longitude: -122.2561),
    CLLocationCoordinate2D(latitude: 37.7849, longitude: -122.5075),
    CLLocationCoordinate2D(latitude: 37.5658, longitude: -122.3237),
    CLLocationCoordinate2D(latitude: 37.4194, longitude: -122.2131),
    CLLocationCoordinate2D(latitude: 37.4468, longitude: -122.1609),
    CLLocationCoordinate2D(latitude: 37.4480, longitude: -122.1593),
    CLLocationCoordinate2D(latitude: 37.4418, longitude: -122.1585),
    CLLocationCoordinate2D(latitude: 37.4424, longitude: -122.1613),
    CLLocationCoordinate2D(latitude: 37.4295 longitude: -122.1692),
    CLLocationCoordinate2D(latitude: 37.4256, longitude: -122.1761),
    CLLocationCoordinate2D(latitude: 37.4392, longitude: -122.1730),
    CLLocationCoordinate2D(latitude: 37.4522, longitude: -122.1844),
    CLLocationCoordinate2D(latitude: 37.4250, longitude: -122.1673),
    CLLocationCoordinate2D(latitude: 37.4234, longitude: -122.1748),
    CLLocationCoordinate2D(latitude: 37.4220, longitude: -122.1627),
    CLLocationCoordinate2D(latitude: 37.4300, longitude: -122.1618)]*/
    
    func generateFakeFriends() {
        //mapView.removeAnnotations(mapView.annotations)
        
        /*
         for i in 0..<10 {
            generateOneFriend()
        }*/
        
        var fakeFriends:[CLLocationCoordinate2D] = []
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.4390, longitude: -122.1583))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.4609, longitude: -122.1388))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.4842, longitude: -122.2300))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.4927, longitude: -122.2286))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.5488, longitude: -122.3101))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.7800, longitude: -122.4039))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.7871, longitude: -122.4057))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.8018, longitude: -122.4118))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.8055, longitude: -122.4233))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.7988, longitude: -122.4295))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.7605, longitude: -122.4686))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.7735, longitude: -122.4220))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.7735, longitude: -122.4221))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.3920, longitude: -122.0802))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.3895, longitude: -122.1101))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.3739, longitude: -122.1210))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.4636, longitude: -122.4286))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.7857, longitude: -122.4011))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.4306, longitude: -122.2561))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.7849, longitude: -122.5075))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.5658, longitude: -122.3237))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.4194, longitude: -122.2131))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.4468, longitude: -122.1609))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.4480, longitude: -122.1593))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.4418, longitude: -122.1585))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.4424, longitude: -122.1613))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.4295, longitude: -122.1692))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.4256, longitude: -122.1761))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.4392, longitude: -122.1730))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.4522, longitude: -122.1844))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.4250, longitude: -122.1673))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.4234, longitude: -122.1748))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.4220, longitude: -122.1627))
        fakeFriends.append(CLLocationCoordinate2D(latitude: 37.4300, longitude: -122.1618))
        let faker = Faker(locale: "en")
        for friend in fakeFriends {
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = friend
            let first = faker.name.firstName()
            let last = faker.name.lastName()
            annotation.title = "\(first)"
            annotation.subtitle = "\(last)"
            mapView.addAnnotation(annotation)
            //friendPins.append(annotation)
        }
        
        /*
        for i in 0..<fakeFriends.count {
            
        }*/
        
        for annotation in self.mapView.annotations {
            if let lastCheckinName = lastCheckin?.name, let sub = annotation.subtitle {
                if let sub = annotation.subtitle {
                    if lastCheckinName == sub {
                        continue
                    }
                }
                
            }
            if annotation is MKUserLocation {
                continue
            }
            self.mapView.view(for: annotation)?.isHidden = true
        }
    }
    
    func generateOneFriend() {
        
        let faker = Faker(locale: "en")
        let coord = CLLocationCoordinate2D(latitude: faker.address.latitude(), longitude: faker.address.longitude())
        let loc = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        if let origin = origin {
            if loc.distance(from: origin) > 1609344 {
                return
            }
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coord
        let first = faker.name.firstName()
        let last = faker.name.lastName()
        annotation.title = "\(first)"
        annotation.subtitle = "\(last)"
        mapView.addAnnotation(annotation)
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is HeatMapOverlay {
            print("HEATMAP")
            return HeatMapOverlayRenderer(overlay: overlay, overlayImage: #imageLiteral(resourceName: "bay3000"))
        }
        print("NO HEAT")
        
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation is MKUserLocation {
            return nil
        }
        
        
        let reuseId = "friendpin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor(red:0.18, green:0.74, blue:0.24, alpha:1.0)
        pinView?.canShowCallout = true
        pinView?.isHidden = true
        if let lastCheckinName = lastCheckin?.name, let sub = annotation.subtitle {
            if let sub = annotation.subtitle {
                if lastCheckinName == sub {
                    pinView?.isHidden = false
                    pinView?.pinTintColor = UIColor(red:0.41, green:0.36, blue:0.96, alpha:1.0)
                }
            }
            
        }
        
        //if annotation.description == "friendPin" {
           //pinView?.isHidden = true
        //}
        
        //let smallSquare = CGSize(width: 30, height: 30)
        //let button = UIButton(type: .infoLight)
        //button.addTarget(self, action: "pinTapped", for: .touchUpInside)
        //pinView?.rightCalloutAccessoryView = button
        return pinView
    }
    
    @objc func pinTapped() {
            print("Pin tapped")
    }
    
    /*
    func mapView(mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        print("RENDER")
        
        return DTMHeatmapRenderer(overlay: overlay)
    }
*/
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Got Location!")
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            //mapView.setRegion(region, animated: true)
            origin = location
            let originLat = Double(location.coordinate.latitude)
            let originLon = Double(location.coordinate.longitude)
            UserDefaults.standard.set(originLat, forKey: "originLat")
            UserDefaults.standard.set(originLon, forKey: "originLon")
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

class NavigationImageView: UIImageView {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: 100, height: 40)
    }
}
