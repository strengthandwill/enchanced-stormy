//
//  ViewController.swift
//  Stormy
//
//  Created by Poh Kah Kong on 9/9/15.
//  Copyright (c) 2015 Algomized. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var curentTemperateLabel: UILabel?
    @IBOutlet weak var currentHumidityLabel: UILabel?
    @IBOutlet weak var currentPrecipitationLabel: UILabel?
    @IBOutlet weak var currentWeatherIcon: UIImageView?
    @IBOutlet weak var currentWeatherSummary: UILabel?
    @IBOutlet weak var refreshButton: UIButton?
    @IBOutlet weak var activityIndictator: UIActivityIndicatorView?
    
    private let forecastAPIKey = "770b057c323d603d9c8a15beeeea7f06"
    let coordinate: (lat: Double, long: Double) = (1.3,103.8)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        retreiveWeatherForecast()
    }
    
    func retreiveWeatherForecast() {
        let forecastService = ForecastService(APIKey: forecastAPIKey)
        forecastService.getForecast(coordinate.lat, long: coordinate.long) {
            (let currently) in
            if let currentWeather = currently {
                dispatch_async(dispatch_get_main_queue()) {
                    if let temperature = currentWeather.temperature {
                        self.curentTemperateLabel?.text = "\(temperature)º"
                    }
                    if let humidity = currentWeather.humidity {
                        self.currentHumidityLabel?.text = "\(humidity)%"
                    }
                    if let precipitation = currentWeather.precipProbability {
                        self.currentPrecipitationLabel?.text = "\(precipitation)%"
                    }
                    if let icon = currentWeather.icon {
                        self.currentWeatherIcon?.image = icon
                    }
                    if let summary = currentWeather.summary {
                        self.currentWeatherSummary?.text = summary
                    }
                    self.toggleRefreshAnimation(false)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func refreshWeather() {
        toggleRefreshAnimation(true)
        retreiveWeatherForecast()
    }
    
    func toggleRefreshAnimation(on: Bool) {
        refreshButton?.hidden = on
        if on {
            activityIndictator?.startAnimating()
        } else {
            activityIndictator?.stopAnimating()
        }
    }
}

