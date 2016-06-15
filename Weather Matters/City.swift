//
//  City.swift
//  Weather Matters
//
//  Created by Ellen Shin on 6/12/16.
//  Copyright © 2016 Ellen Shin. All rights reserved.
//

import Foundation
import Alamofire

class City {
    
    private var _city: String!
    private var _state: String!
    private var _long: Double!
    private var _lat: Double!
    private var _loc: String!
    private var _country: String!
    
    init(loc: String) {
        self._loc = loc
    }
    var country: String {
        return self._country
    }
    
    var city: String {
        return self._city
    }
    
    var state: String {
        return self._state
    }
    
    var long: Double {
        return self._long
    }
    
    var lat: Double {
        return self._lat
    }
    
    func downloadDetails(completed: downloadComplete) {
        let url = "\(URL_DETAILS)\(self._loc.stringByReplacingOccurrencesOfString(" ", withString: "%20"))"
        print(url)
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                let city = dict["geobytescity"] as? String!
                let state = dict["geobytescode"] as? String!
                let country = dict["geobytescountry"] as? String!
                let long = dict["geobyteslongitude"] as? String!
                let lat = dict["geobyteslatitude"] as? String!
                
                self._city = city
                self._state = state
                self._long = Double(long!)
                self._lat = Double(lat!)
                self._country = country
                completed()
            }
        }
    }
}