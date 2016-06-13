//
//  ViewController.swift
//  Weather Matters
//
//  Created by Ellen Shin on 6/9/16.
//  Copyright © 2016 Ellen Shin. All rights reserved.
//

import UIKit
import MapKit
import CalendarView
import SwiftMoment

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, CalendarViewDelegate {

    @IBOutlet weak var todayWeatherIcon: UIImageView!
    @IBOutlet weak var mapPin: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var todayLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var todayTempLbl: UILabel!
    @IBOutlet weak var calendar: CalendarView!
    @IBOutlet weak var currentPrecipLbl: UILabel!
    @IBOutlet weak var currentHumidLbl: UILabel!
    @IBOutlet weak var currentWindLbl: UILabel!
    @IBOutlet weak var currentSunriseLbl: UILabel!
    @IBOutlet weak var currentSunsetLbl: UILabel!
    @IBOutlet weak var currentSummaryLbl: UILabel!
    @IBOutlet weak var precipTag: UILabel!
    @IBOutlet weak var humidTag: UILabel!
    @IBOutlet weak var windTag: UILabel!
    @IBOutlet weak var sunriseTag: UILabel!
    @IBOutlet weak var sunsetTag: UILabel!
    
    var sevenDays: NextSevenDays!
    var locationManager = CLLocationManager()
    var location: CLLocationCoordinate2D!
    
    @IBOutlet weak var calendarImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todayWeatherIcon.image = todayWeatherIcon.image?.invertedImage()
        mapPin.image = mapPin.image?.invertedImage()
        calendarImg.image = calendarImg.image?.invertedImage()
        updateLocation()
        
        tableView.delegate = self
        tableView.dataSource = nil
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.designateDataSource(_:)), name: "locationDataLoaded", object: nil)
       
        
    }
    
    func calendarDidSelectDate(date: Moment) {
        title = date.format("MMMM d, yyyy")
    }
    
    func calendarDidPageToDate(date: Moment) {
        title = date.format("MMMM d, yyyy")
    }

    @IBAction func locationSearchBtn(sender: AnyObject) {
        
    }
    
    func designateDataSource(notif: AnyObject) {
        
        tableView.dataSource = self
        loadTodayData(0)
        precipTag.hidden = false
        humidTag.hidden = false
        sunriseTag.hidden = false
        sunsetTag.hidden = false
        currentSummaryLbl.hidden = false
        windTag.hidden = false
        tableView.reloadData()
    }
    
    func updateLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func getCityAndState() {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: self.location.latitude, longitude: self.location.longitude)
        geoCoder.reverseGeocodeLocation(location)
        {
            (placemarks, error) -> Void in
            
            let placeArray = placemarks as [CLPlacemark]!
            
            var placeMark: CLPlacemark!
            placeMark = placeArray?[0]
            
            if let state = placeMark.addressDictionary?["State"] as? String
            {
                self.stateLbl.text = state
            }
            
            if let city = placeMark.addressDictionary?["City"] as? String
            {
                self.cityLbl.text = city
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if location == nil {
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            location = locValue
            print(location.longitude)
            print(location.latitude)
            sevenDays = NextSevenDays(long: location.longitude, lat: location.latitude)
            self.getCityAndState()
            sevenDays.generateNewData { () -> () in
                self.sevenDays.getDates()
            }
        } else {
            return
        }
        
    }
    
    func loadTodayData(nthDay: Int) {
        dispatch_async(dispatch_get_main_queue()) {
            let todayDay = self.sevenDays.getNthDay(nthDay)
            self.todayWeatherIcon.image = todayDay.weatherImg
            var today = todayDay.date.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet()).joinWithSeparator("")
            today = today.stringByReplacingOccurrencesOfString(" ", withString: "")
            today = today.stringByReplacingOccurrencesOfString("/", withString: "")
            self.todayLbl.text = today
            
            var date = todayDay.date.componentsSeparatedByCharactersInSet(NSCharacterSet.letterCharacterSet()).joinWithSeparator("")
            date = date.stringByReplacingOccurrencesOfString(" ", withString: "")
            self.dateLbl.text = date
            self.todayTempLbl.text = todayDay.temp
            self.currentPrecipLbl.text = todayDay.precipitation
            self.currentHumidLbl.text = todayDay.humidity
            self.currentWindLbl.text = todayDay.wind
            self.currentSunsetLbl.text = todayDay.sunset
            self.currentSunriseLbl.text = todayDay.sunrise
            self.currentSummaryLbl.text = todayDay.summary
            self.tableView.reloadData()
        }

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        loadTodayData(indexPath.row)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 79.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("NextDayCell") as? NextDayCell {
            
            let day = sevenDays.getNthDay(indexPath.row)
            cell.configureCell(day)
            return cell
        } else {
            return NextDayCell()
        }
    }


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}

