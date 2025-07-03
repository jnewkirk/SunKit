//
//  DateInterval + Ext.swift
//  SunKit
//
//  Created by Jim Newkirk on 3/14/25.
//

import Foundation

extension DateInterval {
    internal func inDateInterval(dates: [Date?]) -> Date? {
        for date in dates {
            if let date, self.contains(date) {
                return Date(timeIntervalSince1970: Double(Int(date.timeIntervalSince1970)))
            }
        }

        return nil
    }

    internal init?(start: Date?, end: Date?) {
        guard let start, let end else { return nil }

        if start < end {
            self.init(start: start, end: end)
        } else {
            self.init(start: end, end: start)
        }
    }
}
