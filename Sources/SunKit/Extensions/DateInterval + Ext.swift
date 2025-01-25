//
//  DateInterval + Ext.swift
//  SunKitTests
//
//  Created by Jim Newkirk on 1/22/25.
//

import Foundation

extension DateInterval {
    init?(start: Date?, end: Date?) {
        guard let start, let end else { return nil }
        
        self.init(start: start, end: end)
    }
    
    func hoursMinutes() -> (hours: Int, minutes: Int) {
        let hours = Int(self.duration) / 3600
        let minutes = (Int(self.duration) % 3600) / 60
        
        return (hours, minutes)
    }
}
