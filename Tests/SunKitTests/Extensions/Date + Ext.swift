//
//  Date + Ext.swift
//  SunKit
//
//  Created by Jim Newkirk on 3/14/25.
//

import Foundation

extension Date {
    private static let cachedCalendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone.current
        return calendar
    }()
    
    func add(seconds: Int) -> Date {
        return Calendar.current.date(byAdding: .second, value: seconds, to: self) ?? self
    }
    
    func add(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self) ?? self
    }
    
    func add(hours: Int) -> Date {
        Calendar.current.date(byAdding: .hour, value: hours, to: self) ?? self
    }
    
    func add(days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }
}
