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
    private var _weatherImg: UIImage!
    
    init(date: String, temp: String, image: UIImage) {
        _date = date
        _temp = temp
        _weatherImg = image.invertedImage()
    }
    
    var temp: String {
        return _temp
    }
    
    var date: String {
        return _date
    }
    
    func setDate(date: String) {
        self._date = date
    }
    
    var weatherImg: UIImage {
        return _weatherImg
    }
}