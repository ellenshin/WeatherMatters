//
//  ViewController.swift
//  Weather Matters
//
//  Created by Ellen Shin on 6/9/16.
//  Copyright © 2016 Ellen Shin. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var todayWeatherIcon: UIImageView!
    @IBOutlet weak var mapPin: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var todayLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var todayTempLbl: UILabel!
    @IBOutlet weak var currentPrecipLbl: UILabel!
    @IBOutlet weak var currentHumidLbl: UILabel!
    @IBOutlet weak var currentWindLbl: UILabel!
    @IBOutlet weak var currentSunriseLbl: UILabel!
    @IBOutlet weak var currentSunsetLbl: UILabel!
    @IBOutlet weak var currentSummaryLbl: UILabel!
    @IBOutlet weak var nowTempLbl: UILabel!
    
    
    
    var sevenDays: NextSevenDays!
    var locationManager = CLLocationManager()
    var searchingOtherLocation = false
    
    @IBOutlet weak var calendarImg: UIImageView!
    override func viewDidLoad() {
        
        dispatch_async(dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("LoadingVC", sender: self)
        }
        super.viewDidLoad()
        todayWeatherIcon.image = todayWeatherIcon.image?.invertedImage()
        mapPin.image = mapPin.image?.invertedImage()
        calendarImg.image = calendarImg.image?.invertedImage()
        updateLocation()
        
        tableView.delegate = self
        tableView.dataSource = nil
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.designateDataSource), name: "locationDataLoaded", object: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.undesignateDataSource), name: "undesignateDataSource", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.otherLocationLoaded), name: "otherLocationLoaded", object: nil)
       
        
    }
    
    @IBAction func calendarBtnPressed(sender: AnyObject) {
        loadTodayData(0)
    }

    @IBAction func currentLocBtnPressed(sender: AnyObject) {
        if searchingOtherLocation == false {
            return
        } else {
            location = currentLoc
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "undesignateDataSource", object: nil))
            let selectedCity = currentCity!
            selectedCity.downloadDetails { () -> () in
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "otherLocationLoaded", object: nil))
                searchedCity = selectedCity
                self.searchingOtherLocation = false
            }
        }
    }
    
    func undesignateDataSource() {
        
        tableView.dataSource = nil
    }
    
    func designateDataSource() {
        
        tableView.dataSource = self
        loadTodayData(0)
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "finishedLoading", object: nil))
        }
    }
    
    func updateLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func getOtherCityAndState() {
        self.stateLbl.text = "\(searchedCity!.state), \(searchedCity!.country)"
        self.cityLbl.text = searchedCity!.city
    }
    
    func getCityAndState() {
        if searchingOtherLocation == false {
            let geoCoder = CLGeocoder()
            let loc = CLLocation(latitude: location.latitude, longitude: location.longitude)
            currentLoc = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            geoCoder.reverseGeocodeLocation(loc)
            {
                (placemarks, error) -> Void in
                
                let placeArray = placemarks as [CLPlacemark]!
                
                var placeMark: CLPlacemark!
                placeMark = placeArray?[0]
                
                if let state = placeMark.addressDictionary?["State"] as? String
                {
                    if let country = placeMark.addressDictionary?["Country"] as? String {
                        self.stateLbl.text = "\(state), \(country)"
                    }
                }
                
                if let city = placeMark.addressDictionary?["City"] as? String
                {
                    self.cityLbl.text = city
                    currentCity = City(loc: "\(self.cityLbl.text!), \(self.stateLbl.text!)")

                }
            }
        } else {
            getOtherCityAndState()
        }
    }
    
    func otherLocationLoaded() {
        searchingOtherLocation = true
        loadSevenDays()
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
    
    func loadSevenDays() {
        sevenDays = NextSevenDays(long: location.longitude, lat: location.latitude)
        sevenDays.generateNewData { () -> () in
            self.sevenDays.getDates()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if location == nil {
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            location = locValue
            loadSevenDays()
        } else {
            return
        }
        
    }
    
    func loadTodayData(nthDay: Int) {
        dispatch_async(dispatch_get_main_queue()) {
            self.getCityAndState()
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
            self.nowTempLbl.text = nowTemp
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        loadTodayData(indexPath.row)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65.0
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

