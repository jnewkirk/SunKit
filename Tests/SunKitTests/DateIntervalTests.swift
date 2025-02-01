//
//  DateIntervalTests.swift
//  SunKitTests
//
//  Copyright © 2025 James Newkirk, Brad Wilson. All rights reserved.
//

import Testing
import Foundation
@testable import SunKit

struct DateIntervalTests {
    @Test("Valid Start / End -> DateInterval")
    func validDateInterval() async throws {
        let initialTime = Date.now
        let start = initialTime.addingTimeInterval(60)
        let end = initialTime.addingTimeInterval(120)
        
        let dateInterval = DateInterval(start: start, end: end)
        try #require(dateInterval != nil)
    }
    
    @Test("Start = nil / End = valid date -> nil")
    func nilStartDate() async throws {
        let dateInterval = DateInterval(start: nil, end: Date.now)
        try #require(dateInterval == nil)
    }
    
    @Test("Start = valid date / End = nil -> nil")
    func nilEndDate() async throws {
       let dateInterval = DateInterval(start: Date.now, end: nil)
        try #require(dateInterval == nil)
    }
    
    @Test("Start = nil / End = nil -> nil")
    func nilStartEnd() async throws {
       let dateInterval = DateInterval(start: nil, end: nil)
        try #require(dateInterval == nil)
    }
}

private extension DateInterval {
    init?(start: Date?, end: Date?) {
        guard let start, let end else { return nil }
        
        self.init(start: start, end: end)
    }
}
