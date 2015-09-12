//
//  ViewController.swift
//  Stormy
//
//  Created by Poh Kah Kong on 9/9/15.
//  Copyright (c) 2015 Algomized. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var weatherIcon: UIImageView?
    @IBOutlet weak var summaryLabel: UILabel?
    @IBOutlet weak var sunriseTimeLabel: UILabel?
    @IBOutlet weak var sunsetTimeLabel: UILabel?
    @IBOutlet weak var lowTemperatureLabel: UILabel?
    @IBOutlet weak var highTemperatureLabel: UILabel?
    @IBOutlet weak var precipitationLabel: UILabel?
    @IBOutlet weak var humidityLabel: UILabel?
    
    
    var dailyWeather: DailyWeather? {
        didSet {
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }
    
    func configureView() {
        if let weather = dailyWeather {
            // Update UI with informaton from the data model
            weatherIcon?.image = weather.largeIcon
            summaryLabel?.text = weather.summary
            sunriseTimeLabel?.text = weather.sunriseTime
            sunsetTimeLabel?.text = weather.sunsetTime
            if let lowTemp = weather.minTemperature {
                lowTemperatureLabel?.text = "\(lowTemp)º"
            }
            if let highTemp = weather.maxTemperature {
                highTemperatureLabel?.text = "\(highTemp)º"
            }
            if let rain = weather.precipChance {
                precipitationLabel?.text = "\(rain)%"
            }
            if let humidity = weather.humidity {
                humidityLabel?.text = "\(humidity)%"
            }
            self.title = weather.day
        }
        
        // Configure nav bar back button
        if let buttonFont = UIFont(name: "HelveticaNeue-Thin", size: 20.0) {
            let buttonBarAttributesDictionary: [NSObject: AnyObject]? = [
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: buttonFont
            ]
            UIBarButtonItem.appearance().setTitleTextAttributes(buttonBarAttributesDictionary, forState: .Normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}