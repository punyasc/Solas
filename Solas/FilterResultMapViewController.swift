//
//  FilterResultMapViewController.swift
//  Solas
//
//  Created by Punya Chatterjee on 12/5/17.
//  Copyright © 2017 Punya Chatterjee. All rights reserved.
//

import UIKit
import YelpAPI

class FilterResultMapViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    var pois:[SolasPOI]?
    var poiAnnotations:[MKPointAnnotation]?
    var chosenPoi:SolasPOI?
    //let dict = NSDictionary(dictionary: [MKAnnotation: SolasPOI])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupYelp()
        addHeatmapOverlay()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generateYelpCategories(with filters:[String]) -> [String] {
        var yelpCategories:[String] = []
        for filter in filters {
            yelpCategories += filterToCategory(filter)
        }
        print(yelpCategories)
        return yelpCategories
    }
    
    func filterToCategory(_ filter: String) -> [String] {
        switch filter {
        case "Clubs":
            return ["danceclubs"]
        case "Bars":
            return ["bars"]
        case "Cafes":
            return ["cafes"]
        case "Restaurants":
            return ["restaurants"]
        case "Outdoor Spaces":
            return ["parks", "beaches"]
        case "Recreation":
            return ["active", "arts"]
        case "Dancing":
            return ["danceclubs"]
        case "Live Music":
            return ["musicvenues"]
        case "Places to Chat":
            return ["divebars", "speakeasies", "cafes"]
        case "Places to Work":
            return ["coffee"]
        default:
            return []
        }
    }
    
    func setupYelp() {
        print(">>MAP SETUP YELP")
        let appId = "t7_yp3VWCv7bsvqwDf_rGw"
        let appSecret = "7TWw48rj1Rsvl2qcewGyHhl3feZ9BFJZRiIgjldo6zM8BQia1gI6dMi8BYYZme8Q"
        print("setting up yelp")
        // Search for 3 dinner restaurants
        let originLat = UserDefaults.standard.double(forKey: "originLat")
        let originLon = UserDefaults.standard.double(forKey: "originLon")
        var query = YLPQuery(location: "Palo Alto, CA")
        if originLat != nil && originLon != nil {
            print("Using User Location for Yelp Query")
            let ylpcoord = YLPCoordinate(latitude: originLat, longitude: originLon)
            query = YLPQuery(coordinate: ylpcoord)
        }
        query.sort = YLPSortType.bestMatched
        query.limit = 10
        if let filters = UserDefaults.standard.stringArray(forKey: "HotNowFilters") {
            query.categoryFilter = generateYelpCategories(with: filters)
        }
        pois = []
        poiAnnotations = []
        //dict
        YLPClient.authorize(withAppId: appId, secret: appSecret) { (client, error) in
            client?.search(with: query) { (search, error) in
                if error == nil {
                    print("no errors!")
                }
                let firstName = search?.businesses.first?.name
                let businesses = search?.businesses
                for business in businesses! {
                    print("Name: \(business.name)")
                    let url = business.imageURL ?? URL(string:"https://i.pinimg.com/736x/4e/b8/97/4eb897ea1f550e323993e70042d823e5--kyoto-baltimore.jpg")
                    let data = try? Data(contentsOf: url!)
                    let image = UIImage(data: data!)
                    var tags:[String] = []
                    for category in business.categories {
                        tags.append(category.name)
                    }
                    let thisPoi = SolasPOI(name: business.name, thumbnail: image!, solasRank: 0.0, location: business.location, yelpID: business.identifier, rating: business.rating, numRatings: business.reviewCount, tags: tags)
                    self.pois?.append(thisPoi)
                    self.dropPin(thisPoi)
                }
                self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            }
        }
    }
    
    func dropPin(_ poi: SolasPOI) {
        
        if let coor = poi.location.coordinate {
            let loc = CLLocation(latitude: coor.latitude, longitude: coor.longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = loc.coordinate
            annotation.title = "\(poi.name)"
            poiAnnotations?.append(annotation)
            print("JUST SET:")
            mapView.addAnnotation(annotation)
            
        }
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dest = segue.destination as? POIViewController else { return }
        dest.navigationItem.title = chosenPoi!.name
        dest.chosenPOI = chosenPoi
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

extension FilterResultMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? MKPointAnnotation {
            let index:Int = (poiAnnotations?.index(of: annotation))!
            print("INDEX:", index)
            chosenPoi = pois![index]
            performSegue(withIdentifier: "MapPOIChosen", sender: self)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is HeatMapOverlay {
            print("HEATMAP")
            return HeatMapOverlayRenderer(overlay: overlay, overlayImage: #imageLiteral(resourceName: "bay3000"))
        }
        print("NO HEATMAP")
        return MKOverlayRenderer()
    }
    /*
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "filterpin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = .green
        pinView?.canShowCallout = true
        pinView?.isHidden = true
        //let smallSquare = CGSize(width: 30, height: 30)
        //let button = UIButton(type: .infoLight)
        //button.addTarget(self, action: "pinTapped", for: .touchUpInside)
        //pinView?.rightCalloutAccessoryView = button
        return pinView
    }*/
}
