//
//  NSExtensions.swift
//  Stormy
//
//  Created by Poh Kah Kong on 22/11/15.
//  Copyright © 2015 Algomized. All rights reserved.
//

import Foundation

extension NSDate
{
    func hour() -> Int {
        //Get Hour
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Hour, fromDate: self)
        let hour = components.hour
        
        //Return Hour
        return hour
    }
    
    
    func minute() -> Int {
        //Get Minute
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Minute, fromDate: self)
        let minute = components.minute
        
        //Return Minute
        return minute
    }
    
    func second() -> Int {
        //Get Minute
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Second, fromDate: self)
        let minute = components.second
        
        //Return Minute
        return minute
    }
    
    func totalSeconds() -> Int {
        return hour()  * 3600 + minute() * 60 + second()
    }
    
    func toShortTimeString() -> String {
        //Get Short Time String
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        let timeString = formatter.stringFromDate(self)
        
        //Return Short Time String
        return timeString
    }
}
