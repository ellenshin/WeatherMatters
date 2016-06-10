//
//  NextSevenDays.swift
//  Weather Matters
//
//  Created by Ellen Shin on 6/9/16.
//  Copyright © 2016 Ellen Shin. All rights reserved.
//

import Foundation
import UIKit
import ForecastIO

class NextSevenDays {
    
    private var _days: [Day]?
    var dateFormatter = NSDateFormatter()
    let cal: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    let forecastIOClient = APIClient(apiKey: "a2d38be2948cf8e5bb3aef11f7e047c2")
    let longitude: Double!
    let latitude: Double!
    
    required init(long: Double, lat: Double) {
        _days = [Day]()
        longitude = long
        latitude = lat
    }
    
    func getDates() {
        var currentDate = NSDate()
        for index in 0..<7 {
            if index == 0 {
            let date = _days![index]
            dateFormatter.dateFormat = "EEEE MM/dd"
            let convertedDate = dateFormatter.stringFromDate(currentDate)
            print(convertedDate)
            date.setDate(convertedDate)
            currentDate = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 1, toDate: currentDate, options: [])!
            currentDate = cal.dateBySettingHour(12, minute: 0, second: 0, ofDate: currentDate, options: NSCalendarOptions())!
            } else {
                
                let date = _days![index]
                dateFormatter.dateFormat = "EEEE MM/dd"
                let convertedDate = dateFormatter.stringFromDate(currentDate)
                print(convertedDate)
                date.setDate(convertedDate)
                currentDate = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 1, toDate: currentDate, options: [])!
            }
        }
        
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "locationDataLoaded", object: nil))
    }
    
    func generateNewData(completed: downloadComplete) {
            self.forecastIOClient.getForecast(latitude: self.latitude, longitude: self.longitude) { (currentForecast, error) in
                if let currentForecast = currentForecast {
                    if let dailyDict = currentForecast.daily {
                        if let data = dailyDict.data {
                            for index in 0..<7 {
                                let tempMin: Int = Int(round(data[index].temperatureMin!))
                                let tempMax: Int = Int(round(data[index].temperatureMax!))
                                let image = UIImage(named: (data[index].icon?.rawValue)!)!
                                let day = Day(date: "", temp: "\(tempMax)\(degreeSign) / \(tempMin)\(degreeSign)", image: image)
                                self._days?.append(day)
                            }
                            completed()
                            
                        }
                    }
                } else if let error = error {
                    print(error.debugDescription)
                }
        }
    }
    
    func getNthDay(n: Int) -> Day {
        return self._days![n]
    }
    
}