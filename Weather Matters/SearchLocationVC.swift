//
//  SearchLocationVC.swift
//  Weather Matters
//
//  Created by Ellen Shin on 6/11/16.
//  Copyright © 2016 Ellen Shin. All rights reserved.
//

import UIKit

class SearchLocationVC: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    var cities: [City]!
    var searchedCities: [City]!
    var inSearchMode = false
    override func viewDidLoad() {
        super.viewDidLoad()
        cities = [City]()
        searchedCities = [City]()
        inSearchMode = false
        
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.becomeFirstResponder()
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        parseInCity()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode {
            return searchedCities.count
        }
        return cities.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = searchTableView.dequeueReusableCellWithIdentifier("CityCell", forIndexPath: indexPath) as? CityCell {
            
            var city: City!
            if inSearchMode {
                city = searchedCities[indexPath.row]
            } else {
                city = cities[indexPath.row]
            }
            
            cell.configureCell(city)
            return cell
            
        } else {
            return CityCell()
        }

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            view.endEditing(true)
            searchTableView.reloadData()
        } else {
            
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            searchedCities = cities.filter({$0.city.rangeOfString(lower) != nil})
            searchTableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func parseInCity() {
        
        let path = NSBundle.mainBundle().pathForResource("City-State", ofType: "csv")!
        
        do {
            
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                
                let city = City(city: row["city"]!, state: row["state"]!, long: Double(row["long"]!)!, lat: Double(row["lat"]!)!)
                cities.append(city)
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    

}
