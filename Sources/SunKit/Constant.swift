//
//  Constant.swift
//  SunKitTests
//
//  Copyright © 2025 James Newkirk, Brad Wilson. All rights reserved.
//

import Foundation
import CoreLocation

struct Constant {
    static var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = Constant.utcTimezone
        
        return calendar
    }

    static let utcTimezone = TimeZone(identifier: "UTC")!
}
