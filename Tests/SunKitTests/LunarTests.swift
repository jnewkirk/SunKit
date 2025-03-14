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
            let lunar = try Lunar.make(date: testData.date, coordinate: testData.waypoint.coordinate, timeZone: testData.waypoint.timeZone)
            
            #expect(testData.lunarData.rise == lunar.rise,
                    "Location: \(testData.waypoint.name)")
        }
    }
    
    @Test
    func moonSet() async throws {
        for testData in testDatum {
            let lunar = try Lunar.make(date: testData.date, coordinate: testData.waypoint.coordinate, timeZone: testData.waypoint.timeZone)
            
            #expect(testData.lunarData.set == lunar.set,
                    "Location: \(testData.waypoint.name)")
        }
    }
    
    @Test
    func angle() async throws {
        for testData in testDatum {
            let lunar = try Lunar.make(date: testData.date, coordinate: testData.waypoint.coordinate, timeZone: testData.waypoint.timeZone)
            
            #expect(testData.lunarData.angle == lunar.angle,
                    "Location: \(testData.waypoint.name)")
        }
    }
    
    @Test
    func nextLunarEvents() async throws {
        let lunar = try Lunar.make(date: "2025-03-08T00:58:00Z".toDate()!, coordinate: Constant.puyallup, timeZone: TimeZone(identifier: "America/Los_Angeles")!)
        
        #expect(4 == lunar.nextEvents.count)
        #expect(LunarPhase.full == lunar.nextEvents[0].phase)
        #expect("2025-03-14T06:55:46Z".toDate() == lunar.nextEvents[0].date)
        #expect(LunarPhase.thirdQuarter == lunar.nextEvents[1].phase)
        #expect("2025-03-22T11:30:45Z".toDate() == lunar.nextEvents[1].date)
        #expect(LunarPhase.new == lunar.nextEvents[2].phase)
        #expect("2025-03-29T10:58:53Z".toDate() == lunar.nextEvents[2].date)
        #expect(LunarPhase.firstQuarter == lunar.nextEvents[3].phase)
        #expect("2025-04-05T02:15:48Z".toDate() == lunar.nextEvents[3].date)
    }
    
    @Test
    func illumination() async throws {
        for testData in testDatum {
            let lunar = try Lunar.make(date: testData.date, coordinate: testData.waypoint.coordinate, timeZone: testData.waypoint.timeZone)
            
            #expect(testData.lunarData.illumination == lunar.illumination,
                    "Location: \(testData.waypoint.name)")
        }
    }
    
    @Test
    func phase() async throws {
        for testData in testDatum {
            let lunar = try Lunar.make(date: testData.date, coordinate: testData.waypoint.coordinate, timeZone: testData.waypoint.timeZone)
            
            #expect(testData.lunarData.phase == lunar.phase,
                    "Location: \(testData.waypoint.name)")
        }
    }
}
