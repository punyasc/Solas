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
    
    
    
    
    
    
    var sectionTitles = ["Time", "I Prefer", "Swag"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //expTableView.expandableDelegate = self
        //expTableView.reloadData()
        /*
        table.delegate = self
        table.dataSource = self
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 200
        table.reloadData()
        */
        setupStacks()
        // Do any additional setup after loading the view.
    }
    
    func setupStacks() {
        /*
        let button = UIButton()
        button.setTitle("HWAT", for: .normal)
        button.heightAnchor.constraint(equalToConstant: 15)
        button.widthAnchor.constraint(lessThanOrEqualToConstant: 80)
        button.backgroundColor = UIColor(red:0.10, green:0.41, blue:0.61, alpha:1.0)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(self.filterPressed), for: .touchUpInside)
        self.lookingFor1.addArrangedSubview(button)
        */
 }
    
    @objc func filterPressed(sender: UIButton!) {
        
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

/*
extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    /*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionTitles.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "SectionCell", for: indexPath)
        cell.textLabel?.text = sectionTitles[indexPath.row]
        return cell
    }
    */
    
}*/

/*
extension FilterViewController: ExpandableDelegate {
    
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]? {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell1 = expTableView.dequeueReusableCell(withIdentifier: ExpandedCell.ID) as! ExpandedCell
                cell1.titleLabel.text = "First Expanded Cell"
                let cell2 = expTableView.dequeueReusableCell(withIdentifier: ExpandedCell.ID) as! ExpandedCell
                cell2.titleLabel.text = "Sceond Expanded Cell"
                let cell3 = expTableView.dequeueReusableCell(withIdentifier: ExpandedCell.ID) as! ExpandedCell
                cell3.titleLabel.text = "Third Expanded Cell"
                return [cell1, cell2, cell3]
                
            case 2:
                return nil
            case 3:
                return nil
                
            default:
                break
            }
        default:
            break
        }
        return nil
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightsForExpandedRowAt indexPath: IndexPath) -> [CGFloat]? {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                return [44, 44, 44]
                
            case 2:
                return [33, 33, 33]
                
            case 3:
                return [22]
                
            default:
                break
            }
        default:
            break
        }
        return nil
        
    }
    
    func numberOfSections(in tableView: ExpandableTableView) -> Int {
        return 2
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectRowAt indexPath: IndexPath) {
        //        print("didSelectRow:\(indexPath)")
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectExpandedRowAt indexPath: IndexPath) {
        //        print("didSelectExpandedRowAt:\(indexPath)")
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCell: UITableViewCell, didSelectExpandedRowAt indexPath: IndexPath) {
        if let cell = expandedCell as? ExpandedCell {
            print("\(cell.titleLabel.text ?? "")")
        }
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0, 2, 3:
                guard let cell = expandableTableView.dequeueReusableCell(withIdentifier: ExpandableCell2.ID) else { return UITableViewCell() }
                cell.textLabel?.text = "cha dude"
                return cell
                
            case 1, 4:
                guard let cell = expandableTableView.dequeueReusableCell(withIdentifier: NormalCell.ID)  else { return UITableViewCell() }
                return cell
                
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0, 1, 2, 3, 4:
                guard let cell = expandableTableView.dequeueReusableCell(withIdentifier: NormalCell.ID) else { return UITableViewCell() }
                return cell
                
            default:
                break
            }
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0, 2, 3:
                return 66
                
            case 1, 4:
                return 55
                
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0, 1, 2, 3, 4:
                return 55
                
            default:
                break
            }
        default:
            break
        }
        
        return 44
    }
    
    func expandableTableView(_ expandableTableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = expandableTableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        cell?.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
    }
    
    func expandableTableView(_ expandableTableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /*
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightsForExpandedRowAt indexPath: IndexPath) -> [CGFloat]? {
        return [50.0]
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]? {
        return nil
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let i = indexPath.row
        switch i {
        case 0:
            guard let cell = expTableView.dequeueReusableCell(withIdentifier: "SectionCell") else { return UITableViewCell() }
            cell.textLabel?.text = "swag"
        default:
            break
        }
        return UITableViewCell()
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in expandableTableView: ExpandableTableView) -> Int {
        return 1
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }*/
    
}

*/
