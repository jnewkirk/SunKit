//
//  Test.swift
//  SunKit
//
//  Created by Jim Newkirk on 2/11/25.
//

import CoreLocation
import SwiftAA
import Testing
@testable import SunKit

/// TODO: The test data here isn't very good, because it's shallow, and all the observations happen
/// on the same day. The test data should spread out locations,. dates, etc., as well as include
/// scenarios with no moon rise and/or no moon set.
struct LunarTests {
    var testDatum: [TestLunarData] = []
    
    internal init() async throws {
        testDatum = TestLunarData.load()
    }
    
    @Test func testLocationCount() async throws {
        #expect(testDatum.count == 275)
    }

    @Test
    func moonRise() async throws {
        for testData in testDatum {
            let solar = try Solar.make(date: testData.date, coordinate: testData.coordinate, timeZone: testData.timeZone)
            
            #expect(testData.lunarData.rise == solar.lunar.rise,
                    "Location: \(testData.name)")
        }
    }
    
    @Test
    func moonSet() async throws {
        for testData in testDatum {
            let solar = try Solar.make(date: testData.date, coordinate: testData.coordinate, timeZone: testData.timeZone)
            
            #expect(testData.lunarData.set == solar.lunar.set,
                    "Location: \(testData.name)")
        }
    }
    
    @Test
    func angle() async throws {
        for testData in testDatum {
            let solar = try Solar.make(date: testData.date, coordinate: testData.coordinate, timeZone: testData.timeZone)
            
            #expect(testData.lunarData.angle == solar.lunar.angle,
                    "Location: \(testData.name)")
        }
    }
    
    @Test
    func nextLunarEvents() async throws {
        let solar = try Solar.make(date: "2025-03-08T00:58:00Z".toDate()!, coordinate: Constant.puyallup, timeZone: TimeZone(identifier: "America/Los_Angeles")!)
        
        #expect(4 == solar.lunar.nextEvents.count)
        #expect(LunarPhase.full == solar.lunar.nextEvents[0].phase)
        #expect("2025-03-14T06:55:46Z".toDate() == solar.lunar.nextEvents[0].date)
        #expect(LunarPhase.thirdQuarter == solar.lunar.nextEvents[1].phase)
        #expect("2025-03-22T11:30:45Z".toDate() == solar.lunar.nextEvents[1].date)
        #expect(LunarPhase.new == solar.lunar.nextEvents[2].phase)
        #expect("2025-03-29T10:58:53Z".toDate() == solar.lunar.nextEvents[2].date)
        #expect(LunarPhase.firstQuarter == solar.lunar.nextEvents[3].phase)
        #expect("2025-04-05T02:15:48Z".toDate() == solar.lunar.nextEvents[3].date)
    }
    
    @Test
    func illumination() async throws {
        for testData in testDatum {
            let solar = try Solar.make(date: testData.date, coordinate: testData.coordinate, timeZone: testData.timeZone)
            
            #expect(testData.lunarData.illumination == solar.lunar.illumination,
                    "Location: \(testData.name)")
        }
    }
    
    @Test
    func phase() async throws {
        for testData in testDatum {
            let solar = try Solar.make(date: testData.date, coordinate: testData.coordinate, timeZone: testData.timeZone)
            
            #expect(testData.lunarData.phase == solar.lunar.phase,
                    "Location: \(testData.name)")
        }
    }
}
