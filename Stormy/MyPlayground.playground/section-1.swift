// Playground - noun: a place where people can play

import Foundation

private let forecastAPIKey = "770b057c323d603d9c8a15beeeea7f06"
let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(forecastAPIKey)/")
let forecastURL = NSURL(string: "37.8267,-122.423", relativeToURL: baseURL)