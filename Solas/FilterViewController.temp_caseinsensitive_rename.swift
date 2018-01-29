//
//  FIlterViewController.swift
//  Solas
//
//  Created by Punya Chatterjee on 11/27/17.
//  Copyright © 2017 Punya Chatterjee. All rights reserved.
//

import UIKit
import ExpandableCell

class FilterViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        expTableView.expandableDelegate = self
        // Do any additional setup after loading the view.
    }

    @IBOutlet var expTableView: ExpandableTableView!
    
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

class FilterView
