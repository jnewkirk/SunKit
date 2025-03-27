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
    let testDatum: [TestLunarData]
    
    internal init() {
        testDatum = TestLunarData.load()
    }
    
    @Test func testLocationCount() throws {
        #expect(testDatum.count == 275)
    }

    @Test
    func moonRiseFromMake() {
        for testData in testDatum {
            let lunar = Lunar.make(date: testData.date, coordinate: testData.waypoint.coordinate, timeZone: testData.waypoint.timeZone)
            
            #expect(testData.lunarData.rise == lunar.rise,
                    "Location: \(testData.waypoint.name)")
        }
    }
    
    @Test
    func moonRiseFromRiseAndSet() {
        for testData in testDatum {
            let riseSet = Lunar.riseAndSet(date: testData.date, coordinate: testData.waypoint.coordinate, timeZone: testData.waypoint.timeZone)
            
            #expect(testData.lunarData.rise == riseSet.rise,
                    "Location: \(testData.waypoint.name)")
        }
    }
    
    @Test
    func moonSetFromMake() {
        for testData in testDatum {
            let lunar = Lunar.make(date: testData.date, coordinate: testData.waypoint.coordinate, timeZone: testData.waypoint.timeZone)
            
            #expect(testData.lunarData.set == lunar.set,
                    "Location: \(testData.waypoint.name)")
        }
    }
    
    @Test
    func moonSetFromRiseAndSet() {
        for testData in testDatum {
            let riseSet = Lunar.riseAndSet(date: testData.date, coordinate: testData.waypoint.coordinate, timeZone: testData.waypoint.timeZone)
            
            #expect(testData.lunarData.set == riseSet.set,
                    "Location: \(testData.waypoint.name)")
        }
    }
    
    @Test
    func angle() {
        for testData in testDatum {
            let lunar = Lunar.make(date: testData.date, coordinate: testData.waypoint.coordinate, timeZone: testData.waypoint.timeZone)
            
            #expect(testData.lunarData.angle == lunar.angle,
                    "Location: \(testData.waypoint.name)")
        }
    }
    
    @Test
    func nextLunarEvents() {
        let lunar = Lunar.make(date: "2025-03-08T00:58:00Z".toDate()!, coordinate: Constant.puyallup, timeZone: TimeZone(identifier: "America/Los_Angeles")!)
        
        #expect(4 == lunar.nextEvents.count)
        #expect(LunarPhase.full == lunar.nextEvents[0].phase)
        #expect("2025-03-14T06:56:00Z".toDate() == lunar.nextEvents[0].date)
        #expect(LunarPhase.thirdQuarter == lunar.nextEvents[1].phase)
        #expect("2025-03-22T11:31:00Z".toDate() == lunar.nextEvents[1].date)
        #expect(LunarPhase.new == lunar.nextEvents[2].phase)
        #expect("2025-03-29T10:59:00Z".toDate() == lunar.nextEvents[2].date)
        #expect(LunarPhase.firstQuarter == lunar.nextEvents[3].phase)
        #expect("2025-04-05T02:16:00Z".toDate() == lunar.nextEvents[3].date)
    }
    
    @Test
    func illumination() {
        for testData in testDatum {
            let lunar = Lunar.make(date: testData.date, coordinate: testData.waypoint.coordinate, timeZone: testData.waypoint.timeZone)
            
            #expect(testData.lunarData.illumination == lunar.illumination,
                    "Location: \(testData.waypoint.name)")
        }
    }
    
    @Test
    func phase() {
        for testData in testDatum {
            let lunar = Lunar.make(date: testData.date, coordinate: testData.waypoint.coordinate, timeZone: testData.waypoint.timeZone)
            
            #expect(testData.lunarData.phase == lunar.phase,
                    "Location: \(testData.waypoint.name)")
        }
    }
}
