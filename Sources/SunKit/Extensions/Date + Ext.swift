//
//  Date + Ext.swift
//  SunKit
//
//  Created by Jim Newkirk on 2/25/25.
//

import Foundation

extension Date {
    static let utcTimezone = TimeZone(identifier: "UTC")!
    
    func add(days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }
    
    static let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = Date.utcTimezone
        
        return calendar
    }()
    
    func midnightLocal(timeZone: TimeZone = .current) -> Date {
        let nowComponents = Date.calendar.dateComponents(in: timeZone, from: self)
        let midnightComponents = DateComponents(
            timeZone: timeZone,
            year: nowComponents.year,
            month: nowComponents.month,
            day: nowComponents.day,
            hour: 0,
            minute: 0,
            second: 0
        )
        
        guard let midnight = Date.calendar.date(from: midnightComponents) else {
            assertionFailure("Failed to create midnight date")
            return self
        }
        
        return midnight
    }
    
    func withoutNanoseconds() -> Date {
        return Date(timeIntervalSince1970: Double(Int(self.timeIntervalSince1970)))
    }
}
