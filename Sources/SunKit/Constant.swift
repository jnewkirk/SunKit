//
//  Constant.swift
//  SunKitTests
//
//  Created by James Newkirk on January, 23. 2025.
//  Copyright © 2025 James Newkirk. All rights reserved.
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
