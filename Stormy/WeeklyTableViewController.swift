//
//  WeeklyTableViewController.swift
//  Stormy
//
//  Created by Poh Kah Kong on 11/9/15.
//  Copyright (c) 2015 Algomized. All rights reserved.
//

import UIKit
import CoreLocation

class WeeklyTableViewController: UITableViewController {
    @IBOutlet weak var currentWeatherView: UIView?
    @IBOutlet weak var currentLocalityLabel: UILabel?
    @IBOutlet weak var currentTemperatureLabel: UILabel?
    @IBOutlet weak var currentWeatherIcon: UIImageView?
    @IBOutlet weak var currentPrecipitationLabel: UILabel?
    @IBOutlet weak var currentTemperatureRangeLabel: UILabel?
    
    let forecastAPIKey = "770b057c323d603d9c8a15beeeea7f06"
    let locationService = LocationService()
    var locality: String?    
    var weeklyWeather: [DailyWeather] = []
    var coordinate: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        reloadLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView() {
        // Set table view's background view property
        tableView.backgroundView = BackgroundView()
        
        // Set custom height for table view row
        tableView.rowHeight = 64
        
        // Change the font and size of nav bar text
        if let navBarFont = UIFont(name: "HelveticaNeue-Thin", size: 20.0) {
            let navBarAttributesDictionary: [String: AnyObject]? = [
                NSForegroundColorAttributeName: UIColor.blackColor(),
                NSFontAttributeName: navBarFont
            ]
            navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
            navigationController?.navigationBar.tintColor = UIColor.blackColor()
        }
        
        // Position refresh control above background view
        refreshControl?.layer.zPosition = tableView.backgroundView!.layer.zPosition + 1
        refreshControl?.tintColor = UIColor.whiteColor()
        
        if let currentWeatherView = self.currentWeatherView {
            currentWeatherView.hidden = true
        }        
    }
    
    func reloadLocation() {
        locationService.findLocation() {
            (coordinate, placemark) -> Void in
            if  let placemarkLocality = placemark.locality,
                let placemarkCountry = placemark.country {
                self.coordinate = coordinate
                self.locality = "\(placemarkLocality) ,\(placemarkCountry)"
                self.retreiveWeatherForecast()
            }
        }
    }
    
    @IBAction func refreshWeather() {
        if let refreshControl = refreshControl {
            reloadLocation()
            refreshControl.endRefreshing()
        }
    }
    
    // MARK: - Navigation    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDaily" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dailyWeather = weeklyWeather[indexPath.row]
                let viewController = segue.destinationViewController as! ViewController
                viewController.locality = locality
                viewController.dailyWeather = dailyWeather
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return weeklyWeather.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Forecast"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WeatherCell") as! DailyWeatherTableViewCell
        let dailyWeather = weeklyWeather[indexPath.row]
        if let maxTemp = dailyWeather.maxTemperature {
            cell.temperatureLabel?.text = "\(maxTemp)º"
        }
        if let weatherIcon = dailyWeather.icon {
            cell.weatherIcon?.image = weatherIcon
        }
        if let day = dailyWeather.day {
            cell.dayLabel?.text = day
        }
        return cell
    }
    
    // MARKL - Delegate Methods
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.whiteColor()
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: 14.0)
            header.textLabel!.textColor = UIColor.blackColor()
        }
    }
    
    // MARK: - Weather Fetching
    func retreiveWeatherForecast() {
        let forecastService = ForecastService(APIKey: forecastAPIKey)
        if  let latitude = coordinate?.latitude,
            let longitude = coordinate?.longitude {
            forecastService.getForecast(latitude, long: longitude) {
                (let forecast) in
                if let weatherForecast = forecast {
                    if let currentWeather = weatherForecast.currentWeather {
                        dispatch_async(dispatch_get_main_queue()) {
                            if  let currentLocalityLabel = self.currentLocalityLabel,
                                let locality = self.locality {
                                currentLocalityLabel.text = locality
                            }
                            if let temperature = currentWeather.temperature {
                                self.currentTemperatureLabel?.text = "\(temperature)º"
                            }
                            if let precipitation = currentWeather.precipProbability {
                                self.currentPrecipitationLabel?.text = "Rain: \(precipitation)%"
                            }
                            if let icon = currentWeather.icon {
                                self.currentWeatherIcon?.image = icon
                            }
                        
                            self.weeklyWeather = weatherForecast.weekly
                            
                            if let highTemp = self.weeklyWeather.first?.maxTemperature {
                                if let lowTemp = self.weeklyWeather.first?.minTemperature {
                                    self.currentTemperatureRangeLabel?.text = "↑\(highTemp)º↓\(lowTemp)"
                                }
                            }
                            if let currentWeatherView = self.currentWeatherView {
                                currentWeatherView.hidden = false
                            }
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
}
