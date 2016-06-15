//
//  SearchLocationVC.swift
//  Weather Matters
//
//  Created by Ellen Shin on 6/11/16.
//  Copyright © 2016 Ellen Shin. All rights reserved.
//

import UIKit
import Alamofire
import MapKit

class SearchLocationVC: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    var cities: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cities = [String]()
        
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.becomeFirstResponder()
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "undesignateDataSource", object: nil))
        let selectedCity = City(loc: cities[indexPath.row])
        selectedCity.downloadDetails { () -> () in
            let loc = CLLocationCoordinate2D(latitude: selectedCity.lat, longitude: selectedCity.long)
            otherLoc = loc
            location = otherLoc
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "otherLocationLoaded", object: nil))
            searchedCity = selectedCity
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = searchTableView.dequeueReusableCellWithIdentifier("CityCell", forIndexPath: indexPath) as? CityCell {
            let city = cities[indexPath.row]
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
        
        if searchBar.text != nil && searchBar.text != "" {
            if searchBar.text!.characters.count >= 3 {
                let input = searchBar.text?.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                let url = "\(URL_BASE)\(input!.lowercaseString)"
                Alamofire.request(.GET, url).responseJSON {
                    response in
                    let result = response.result
                    if let cityArray = result.value as? [String] {
                        self.cities = cityArray
                        self.searchTableView.reloadData()
                    }
                    
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }   

}
