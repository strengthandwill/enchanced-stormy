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
    @IBOutlet weak var currentLocalityLabel: UILabel?
    @IBOutlet weak var currentTemperatureLabel: UILabel?
    @IBOutlet weak var currentWeatherIcon: UIImageView?
    @IBOutlet weak var currentPrecipitationLabel: UILabel?
    @IBOutlet weak var currentTemperatureRangeLabel: UILabel?
    
    let locationService = LocationService()
    var weeklyWeather: [DailyWeather] = []
    var coordinate: CLLocationCoordinate2D?
    
    private let forecastAPIKey = "770b057c323d603d9c8a15beeeea7f06"

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        locationService.findLocation() {
            (coordinate, placemark) -> Void in
            var location: String?
            if  let locality = placemark.locality,
                let administrativeArea = placemark.administrativeArea {
                self.coordinate = coordinate
                location = "\(locality) ,\(administrativeArea)"
                self.retreiveWeatherForecast()
            } else {
                self.coordinate = CLLocationCoordinate2D(latitude: 1.3, longitude: 103.8)
                location = "Singapore, SG"
            }
            if  let currentLocalityLabel = self.currentLocalityLabel {
                currentLocalityLabel.text = location
            }
        }
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
    }
    
    @IBAction func refreshWeather() {
        retreiveWeatherForecast()
        refreshControl?.endRefreshing()
    }
    
    // MARK: - Navigation    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDaily" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dailyWeather = weeklyWeather[indexPath.row]
                
                (segue.destinationViewController as! ViewController).dailyWeather = dailyWeather
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
    
    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let highlightColor = UIColor(red: 165/255.0, green: 142/255.0, blue: 203/255.0, alpha: 1.0)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.contentView.backgroundColor = highlightColor
        let highlightView = UIView()
        highlightView.backgroundColor = highlightColor
        cell?.selectedBackgroundView = highlightView
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
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
}
