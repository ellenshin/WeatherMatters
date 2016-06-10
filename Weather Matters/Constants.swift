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