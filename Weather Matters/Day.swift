//
//  Day.swift
//  Weather Matters
//
//  Created by Ellen Shin on 6/9/16.
//  Copyright © 2016 Ellen Shin. All rights reserved.
//

import Foundation
import UIKit

class Day {
    
    private var _temp: String!
    private var _date: String!
    private var _wind: String!
    private var _humidity: String!
    private var _precipitation: String!
    private var _sunrise: String!
    private var _sunset: String!
    private var _summary: String!
    private var _weatherImg: UIImage!
    
    init(date: String, temp: String, image: UIImage, wind: String, humidity: String, precipitation: String, sunrise: String, sunset: String, summary: String) {
        _date = date
        _temp = temp
        _weatherImg = image.invertedImage()
        _wind = wind
        _humidity = humidity
        _precipitation = precipitation
        _sunrise = sunrise
        _sunset = sunset
        _summary = summary
    }
    
    var temp: String {
        return _temp
    }
    
    var date: String {
        return _date
    }
    
    var wind: String {
        return _wind
    }
    
    var humidity: String {
        return _humidity
    }
    
    var precipitation: String {
        return _precipitation
    }
    
    var sunrise: String {
        return _sunrise
    }
    
    var sunset: String {
        return _sunset
    }
    
    var summary: String {
        return _summary
    }
    
    func setDate(date: String) {
        self._date = date
    }
    
    var weatherImg: UIImage {
        return _weatherImg
    }
}