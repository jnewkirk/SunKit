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
}
