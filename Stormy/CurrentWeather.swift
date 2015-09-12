//
//  CurrentWeather.swift
//  Stormy
//
//  Created by Poh Kah Kong on 9/9/15.
//  Copyright (c) 2015 Algomized. All rights reserved.
//

import Foundation
import UIKit

struct CurrentWeather {
    let temperature: Int?
    let humidity: Int?
    let precipProbability: Int?
    let summary: String?
    var icon: UIImage? = UIImage(named: "default.png")

    init(weatherDictionary: [String: AnyObject]) {
        temperature = weatherDictionary["temperature"] as? Int
        if let humidityFloat = weatherDictionary["humidity"] as? Double {
            humidity = Int(humidityFloat * 100)
        } else {
            humidity = nil
        }
        if let precipProbabilityFloat = weatherDictionary["precipProbability"] as? Double {
            precipProbability = Int(precipProbabilityFloat * 100)
        } else {
            precipProbability = nil
        }
        summary = weatherDictionary["summary"] as? String
        
        if let iconString = weatherDictionary["icon"] as? String {
            if let weatherIcon: Icon = Icon(rawValue: iconString) {
                (icon, _) = weatherIcon.toImage()
            }
        }
    }
}
