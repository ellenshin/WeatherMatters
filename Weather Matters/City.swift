//
//  City.swift
//  Weather Matters
//
//  Created by Ellen Shin on 6/12/16.
//  Copyright © 2016 Ellen Shin. All rights reserved.
//

import Foundation

class City {
    
    private var _city: String!
    private var _state: String!
    private var _long: Double!
    private var _lat: Double!
    
    init(city: String, state: String, long: Double, lat: Double) {
        
        self._city = city.lowercaseString
        self._state = state.lowercaseString
        self._lat = lat
        self._long = long
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
}