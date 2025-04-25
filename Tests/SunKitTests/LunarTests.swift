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
            let lunar = Lunar(date: testData.date, coordinate: testData.waypoint.coordinate, timeZone: testData.waypoint.timeZone)
            
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
            let lunar = Lunar(date: testData.date, coordinate: testData.waypoint.coordinate, timeZone: testData.waypoint.timeZone)
            
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
            let lunar = Lunar(date: testData.date, coordinate: testData.waypoint.coordinate, timeZone: testData.waypoint.timeZone)
            
            #expect(testData.lunarData.angle == lunar.angle,
                    "Location: \(testData.waypoint.name)")
        }
    }
    
    @Test
    func nextLunarEvents() {
        let lunar = Lunar(date: "2025-03-08T00:58:00Z".toDate()!, coordinate: Constant.cupertino, timeZone: TimeZone(identifier: "America/Los_Angeles")!)
        
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
            let lunar = Lunar(date: testData.date, coordinate: testData.waypoint.coordinate, timeZone: testData.waypoint.timeZone)
            
            #expect(testData.lunarData.illumination == lunar.illumination,
                    "Location: \(testData.waypoint.name)")
        }
    }
    
    @Test
    func phase() {
        for testData in testDatum {
            let lunar = Lunar(date: testData.date, coordinate: testData.waypoint.coordinate, timeZone: testData.waypoint.timeZone)
            
            #expect(testData.lunarData.phase == lunar.phase,
                    "Location: \(testData.waypoint.name)")
        }
    }
    
    @Test
    func makeRange() throws {
        let formatter = ISO8601DateFormatter()
        let date = try #require(formatter.date(from: "2025-01-22T19:00:00Z"))
        let coordinates = Constant.alienThrone

        let lunars = Lunar.makeRange(from: date, at: coordinates, timeZone: Constant.mountainTimeZone, forDays: 3)
        
        try #require(lunars.count == 3)
        
        #expect(formatter.date(from: "2025-01-22T08:13:00Z") == lunars[0].rise)
        #expect(formatter.date(from: "2025-01-23T09:14:00Z") == lunars[1].rise)
        #expect(formatter.date(from: "2025-01-24T10:16:00Z") == lunars[2].rise)

        #expect(formatter.date(from: "2025-01-22T18:40:00Z") == lunars[0].set)
        #expect(formatter.date(from: "2025-01-23T19:11:00Z") == lunars[1].set)
        #expect(formatter.date(from: "2025-01-24T19:49:00Z") == lunars[2].set)

        // Angles based on midnight, not the current time
        #expect(-13.73.rounded(toIncrement: 0.01) == lunars[0].angle.rounded(toIncrement: 0.01))
        #expect(-24.66.rounded(toIncrement: 0.01) == lunars[1].angle.rounded(toIncrement: 0.01))
        #expect(-35.69.rounded(toIncrement: 0.01) == lunars[2].angle.rounded(toIncrement: 0.01))
    }
}
