//
//  Constant.swift
//  SunKitTests
//
//  Copyright © 2025 James Newkirk, Brad Wilson. All rights reserved.
//

import Foundation
import CoreLocation

public struct Constant {
    static var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = Constant.utcTimezone
        
        return calendar
    }

    // The synodic month (Moon cycle) is 29.53058867 days
    static let synodicMonth = 29.53058867
    
    static let lunarNew = 0.0
    static let lunarFirstQuarter = synodicMonth / 4.0
    static let lunarFull = synodicMonth / 2.0
    static let lunarThirdQuarter = lunarFirstQuarter * 3.0
    
    public static let utcTimezone = TimeZone(identifier: "UTC")!
}
