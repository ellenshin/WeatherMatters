//
//  Constants.swift
//  Weather Matters
//
//  Created by Ellen Shin on 6/9/16.
//  Copyright © 2016 Ellen Shin. All rights reserved.
//

import Foundation
import MapKit

typealias downloadComplete = () -> ()
let degreeSign = NSString(format:"%@", "\u{00B0}") as String
var location: CLLocationCoordinate2D!
var otherLoc: CLLocationCoordinate2D?
var currentLoc: CLLocationCoordinate2D!
var currentCity: City?
var searchedCity: City?
var nowTemp: String!

var dateFormatter = NSDateFormatter()
let URL_BASE = "http://gd.geobytes.com/AutoCompleteCity?callback=&q="
let URL_DETAILS = "http://gd.geobytes.com/GetCityDetails?callback=&fqcn="

func toReadableTime(date: NSDate, timezone: NSTimeZone) -> String {
    dateFormatter.dateFormat = "h:mm a"
    dateFormatter.timeZone = timezone
    return dateFormatter.stringFromDate(date)
}