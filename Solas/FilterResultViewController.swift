//
//  FilterResultViewController.swift
//  Solas
//
//  Created by Punya Chatterjee on 12/4/17.
//  Copyright © 2017 Punya Chatterjee. All rights reserved.
//

import UIKit
import YelpAPI

class FilterResultViewController: UIViewController {

    var selectedFilters: [FilterButton] = []
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var chosenFiltersStack: UIStackView!
    var pois:[SolasPOI] = []
    
    
    @IBOutlet var listContainer: UIView!
    @IBOutlet var mapContainer: UIView!
    @IBOutlet var segControl: UISegmentedControl!
    @IBAction func segFlipped(_ sender: UISegmentedControl) {
        if segControl.selectedSegmentIndex == 0 {
            listContainer.isHidden = false
            mapContainer.isHidden = true
            //performSegue(withIdentifier: "ResultList", sender: self)
        } else {
            listContainer.isHidden = true
            mapContainer.isHidden = false
            //performSegue(withIdentifier: "ResultMap", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for filter in selectedFilters {
            generateAndAddButton(sender: filter)
        }
        //setupYelp()
        //navigationController?.navigationItem.
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generateAndAddButton(sender: UIButton) {
        let newB = FilterButton()
        newB.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        newB.backgroundColor = sender.backgroundColor
        newB.setTitle(sender.titleLabel?.text, for: .normal)
        newB.contentEdgeInsets = UIEdgeInsetsMake(10,10,10,10)
        newB.alpha = 0.0
        newB.rounded = true
        self.chosenFiltersStack.addArrangedSubview(newB)
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            newB.alpha = 1.0
        })
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResultList" {
            if let dest = segue.destination as? FilterResultTableViewController {
                dest.pois = self.pois
                dest.tableView.reloadData()
                print("ResultList performed")
            }
        } else if segue.identifier == "ResultMap" {
            if let dest = segue.destination as? FilterResultMapViewController {
                dest.pois = self.pois
                print("ResultMap performed")
            }
        }
    }
 

}
