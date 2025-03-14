//
//  SolarTests.swift
//  SunKit
//
//  Copyright © 2025 James Newkirk, Brad Wilson. All rights reserved.

import Testing
import Foundation
import CoreLocation
@testable import SunKit

struct SolarTests {
    var testData: [TestSolarData] = []
    
    internal init() async throws {
        testData = TestSolarData.load()
    }
    
    @Test
    func testLocationCount() async throws {
        #expect(testData.count == 246)
    }
    
    @Test
    func makeRange() async throws {
        let formatter = ISO8601DateFormatter()
        let date = try #require(formatter.date(from: "2025-01-22T07:00:00Z"))
        let coordinates = CLLocationCoordinate2D(latitude: 36.148817, longitude: -107.980578)
        
        let solars = try Solar.makeRange(from: date, at: coordinates, timeZone: TimeZone(identifier: "America/Denver")!, forDays: 3)
        
        try #require(solars.count == 3)
        #expect(formatter.date(from: "2025-01-22T14:17:58Z") == solars[0].dawn.actual)
        #expect(formatter.date(from: "2025-01-23T14:17:25Z") == solars[1].dawn.actual)
        #expect(formatter.date(from: "2025-01-24T14:16:52Z") == solars[2].dawn.actual)
    }
    
    @Test
    func solarNoon() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            #expect(testLocation.solarData.solarNoon == solar.solarNoon,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func solarNoonIsDaylight() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)

            let daylight = try #require (solar.daylight)
            let solarNoon = try #require (solar.solarNoon)
            #expect(daylight.contains(solarNoon),
                    "location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func beforeSunriseIsNotDaylight() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            let sunrise = try #require(testLocation.solarData.sunrise)
            let beforeSunrise = sunrise.addingTimeInterval(-1)
            
            let daylight = try #require (solar.daylight)
            #expect(daylight.contains(beforeSunrise) == false,
                    "location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func afterSunsetIsNotDaylight() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            let sunset = try #require(testLocation.solarData.sunset)
            let afterSunset = sunset.addingTimeInterval(1)
            
            let daylight = try #require (solar.daylight)
            #expect(daylight.contains(afterSunset) == false,
                    "location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func sunriseDaylight() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            let sunrise = try #require(testLocation.solarData.sunrise)
            
            let daylight = try #require (solar.daylight)
            #expect(daylight.contains(sunrise),
                    "location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func sunsetDaylight() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            let sunset = try #require(testLocation.solarData.sunset)
            
            let daylight = try #require (solar.daylight)
            #expect(daylight.contains(sunset),
                    "location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func solarAngle() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            #expect(testLocation.solarData.solarAngle == solar.angle,
                    "location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func daylightIntervalSeconds() throws {
        let solar = try Solar.make(date: Date(timeIntervalSince1970: 1737779072), coordinate: Constant.cupertino, timeZone: TimeZone(identifier: "America/Los_Angeles")!)
        
        let daylight = try #require(solar.daylight)
        #expect(36453.0 == daylight.duration)
    }
    
    @Test
    func sunsetPrecedesSunrise() throws {
        // Svalbard
        let solar = try Solar.make(
            date: "2025-04-18T04:00:00Z".toDate()!,
            coordinate: CLLocationCoordinate2D(latitude: 78.22745806736931, longitude: 15.77845128961993),
            timeZone: TimeZone(identifier: "Arctic/Longyearbyen")!
        )
        
        #expect("2025-04-17T23:27:37Z".toDate() == solar.dawn.actual)
        #expect(nil == solar.dawn.astronomical)
        #expect(nil == solar.dawn.civil)
        #expect(nil == solar.dawn.nautical)

        #expect("2025-04-17T22:20:01Z".toDate() == solar.dusk.actual)
        #expect(nil == solar.dusk.astronomical)
        #expect(nil == solar.dusk.civil)
        #expect(nil == solar.dusk.nautical)
    }
}
