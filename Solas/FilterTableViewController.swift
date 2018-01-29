//
//  FilterTableViewController.swift
//  Solas
//
//  Created by Punya Chatterjee on 11/20/17.
//  Copyright © 2017 Punya Chatterjee. All rights reserved.
//

import UIKit
import YelpAPI

class FilterTableViewController: UITableViewController {

    @IBOutlet var topView: UIView!
    @IBOutlet var chosenFiltersStack: UIStackView!
    
    var selectedFilters: [FilterButton] = []
    
    @IBAction func filterPress(_ sender: UIButton) {
        for index in 0..<selectedFilters.count {
            let title = sender.titleLabel?.text
            if title == selectedFilters[index].titleLabel?.text {
                sender.backgroundColor = selectedFilters[index].backgroundColor
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    sender.alpha = 1.0
                })
                selectedFilters[index].removeFromSuperview()
                selectedFilters.remove(at: index)
                return
            }
        }
        
        let title = sender.titleLabel?.text
        print("Fiter tapped: \(title!)")
        let newB = FilterButton()
        newB.rounded = true
        
        newB.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        newB.backgroundColor = sender.backgroundColor
        newB.setTitle(sender.titleLabel?.text, for: .normal)
        newB.contentEdgeInsets = UIEdgeInsetsMake(10,10,10,10)
        newB.alpha = 0.0
        newB.frame.size = CGSize(width: newB.frame.size.width, height: 10)
        newB.layer.cornerRadius = newB.frame.size.height/2
        self.chosenFiltersStack.addArrangedSubview(newB)
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            newB.alpha = 1.0
        })
        
        selectedFilters.append(newB)
        //sender.backgroundColor = .gray
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            sender.alpha = 0.3
        })
        
        //let offset = CGPoint(x: chosenFiltersStack.frame.width - scrollView.frame.width, y: scrollView.contentOffset.y)
        //scrollView.setContentOffset(offset, animated: true)
        saveFilters()
        
    }
    @IBOutlet var scrollView: UIScrollView!
    
    
    func saveFilters() {
        var textFilters:[String] = []
        for filter in selectedFilters {
            textFilters.append(filter.titleLabel!.text!)
        }
        UserDefaults.standard.set(textFilters, forKey: "HotNowFilters")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStacks()
        
        let titleImageView = NavigationImageView()
        titleImageView.image = #imageLiteral(resourceName: "SolasLogoWeb")
        navigationItem.titleView = titleImageView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    @IBOutlet var lookingFor1: UIStackView!
    @IBOutlet var lookingFor2: UIStackView!
    
    func makeButton(title: String, color: UIColor) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        button.layer.cornerRadius = 10
        button.contentEdgeInsets = UIEdgeInsetsMake(10,10,10,10)
        button.addTarget(self, action: #selector(self.filterPressed), for: .touchUpInside)
        
        return button
    }
    
    func setupStacks() {
        /*
        let lookingForColor = UIColor(red:0.62, green:0.20, blue:0.20, alpha:1.0)
        let button1 = makeButton(title: "Clubs", color: lookingForColor)
        let button2 = makeButton(title: "Bars", color: lookingForColor)
        let button3 = makeButton(title: "Cafes", color: lookingForColor)
        let button4 = makeButton(title: "Restaurants", color: lookingForColor)
        let button5 = makeButton(title: "Outdoor Spaces", color: lookingForColor)
        let button6 = makeButton(title: "Recreation", color: lookingForColor)
        self.lookingFor1.addArrangedSubview(button1)
        self.lookingFor1.addArrangedSubview(button2)
        self.lookingFor1.addArrangedSubview(button3)
        self.lookingFor2.addArrangedSubview(button4)
        self.lookingFor2.addArrangedSubview(button5)
        self.lookingFor2.addArrangedSubview(button6)*/
    }
    
    @objc func filterPressed(sender: UIButton!) {
        
    }
    
    override func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
        guard let dest = segue.destination as? FilterResultViewController else { return }
        //dest.chosenFiltersStack = self.chosenFiltersStack
        dest.selectedFilters = self.selectedFilters
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}

extension UIButton {
    
    /// Creates a duplicate of the terget UIButton
    /// The caller specified the UIControlEvent types to copy across to the duplicate
    ///
    /// - Parameter controlEvents: UIControlEvent types to copy
    /// - Returns: A UIButton duplicate of the original button
    func duplicate(forControlEvents controlEvents: [UIControlEvents]) -> UIButton? {
        
        // Attempt to duplicate button by archiving and unarchiving the original UIButton
        let archivedButton = NSKeyedArchiver.archivedData(withRootObject: self)
        guard let buttonDuplicate = NSKeyedUnarchiver.unarchiveObject(with: archivedButton) as? UIButton else { return nil }
        
        // Copy targets and associated actions
        
        self.allTargets.forEach { target in
            
            controlEvents.forEach { controlEvent in
                
                self.actions(forTarget: target, forControlEvent: controlEvent)?.forEach { action in
                    buttonDuplicate.addTarget(target, action: Selector(action), for: controlEvent)
                }
            }
        }
        
        return buttonDuplicate
    }
}

extension UIScrollView {
    func scrollToBottom(animated animated: Bool) {
        if self.contentSize.height < self.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }
    
    func scrollToEnd(animated: Bool) {
        if self.contentSize.width < self.bounds.size.width { return }
        //self.intrinsicContentSize
        
        let rightOffset = CGPoint(x: self.contentSize.width - 40, y: 0)
        self.setContentOffset(rightOffset, animated: animated)
    }
}
