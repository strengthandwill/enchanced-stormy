//
//  LocationService.swift
//  Stormy
//
//  Created by Poh Kah Kong on 21/11/15.
//  Copyright © 2015 Algomized. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var completionHandler: ((CLLocationCoordinate2D, CLPlacemark) -> Void)?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func findLocation(completionHandler: (CLLocationCoordinate2D, CLPlacemark) -> Void) {
        locationManager.startUpdatingLocation()
        self.completionHandler = completionHandler
    }

    @objc func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {
            (placemarks, error) -> Void in
            if let error = error {
                print("Reverse geocoder failed with error " + error.localizedDescription)
                return
            }
            if  let completionHandler = self.completionHandler,
                let placemarks = placemarks where placemarks.count > 0 {
                completionHandler(locations[0].coordinate, placemarks[0])
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
   @objc func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }
}
