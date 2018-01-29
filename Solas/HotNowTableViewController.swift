//
//  HotNowTableViewController.swift
//  Solas
//
//  Created by Punya Chatterjee on 11/20/17.
//  Copyright © 2017 Punya Chatterjee. All rights reserved.
//

import UIKit
import YelpAPI

class HotNowTableViewController: UITableViewController {
    
    var pois:[SolasPOI]  = []
    var chosenPoi:SolasPOI?
    var chosenTag:String?
    
    @IBOutlet var dateLabel: UILabel!
    
    
    let hotnowTags = Tagger(max: 10).shuffleAndReturn()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupYelp()
        print("Did Load")
        let date = Date()
        let cal = Calendar.current
        let hour = cal.component(.hour, from: date)
        let weekDay = cal.component(.weekday, from: date)
        let weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        let dayString = weekDays[weekDay - 1]
        var timeOfDay:String {
            if hour < 5 {
                return "night"
            } else if hour < 11 {
                return "morning"
            } else if hour < 18 {
                return "afternoon"
            } else if hour < 20 {
                return "evening"
            } else {
                return "night"
            }
        }
        let fullString = "\(dayString) \(timeOfDay), "
        dateLabel.text = fullString
        let taggerArray = Tagger(max: 10).shuffleAndReturn()
        print("TAGS", taggerArray)
        
        let titleImageView = NavigationImageView()
        titleImageView.image = #imageLiteral(resourceName: "SolasLogoWeb")
        navigationItem.titleView = titleImageView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Did Appear")
        //setupYelp()
        //tableView.reloadData()
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
        print("ACCESSING")
        
        pois = []
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
                    self.pois.append(thisPoi)
                    print("Should Refresh")
                    DispatchQueue.main.async {
                        print("Will Refresh")
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pois.count == 0 ? 1 : pois.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if pois.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HotNowRegularItem", for: indexPath) as! HotNowTableViewCell
        cell.update(poi: pois[indexPath.row], tag: hotnowTags[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard pois.count > 0 else { return }
        chosenPoi = pois[indexPath.row]
        chosenTag = hotnowTags[indexPath.row]
        performSegue(withIdentifier: "HotNowSelection", sender: self)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        guard let dest = segue.destination as? POIViewController else { return }
        dest.navigationItem.title = chosenPoi!.name
        dest.chosenPOI = chosenPoi
        dest.chosenTag = chosenTag
    }
 

}
