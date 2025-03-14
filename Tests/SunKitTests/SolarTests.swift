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
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.coordinate, timeZone: testLocation.timeZone)
            
            #expect(testLocation.solarData.solarNoon == solar.solarNoon,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func solarNoonIsDaylight() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.coordinate, timeZone: testLocation.timeZone)

            let daylight = try #require (solar.daylight)
            let solarNoon = try #require (solar.solarNoon)
            #expect(daylight.contains(solarNoon))
        }
    }
    
    @Test
    func beforeSunriseIsNotDaylight() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.coordinate, timeZone: testLocation.timeZone)
            let sunrise = try #require(testLocation.solarData.sunrise)
            let beforeSunrise = sunrise.addingTimeInterval(-1)
            
            let daylight = try #require (solar.daylight)
            #expect(daylight.contains(beforeSunrise) == false)
        }
    }
    
    @Test
    func afterSunsetIsNotDaylight() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.coordinate, timeZone: testLocation.timeZone)
            let sunset = try #require(testLocation.solarData.sunset)
            let afterSunset = sunset.addingTimeInterval(1)
            
            let daylight = try #require (solar.daylight)
            #expect(daylight.contains(afterSunset) == false)
        }
    }
    
    @Test
    func sunriseDaylight() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.coordinate, timeZone: testLocation.timeZone)
            let sunrise = try #require(testLocation.solarData.sunrise)
            
            let daylight = try #require (solar.daylight)
            #expect(daylight.contains(sunrise))
        }
    }
    
    @Test
    func sunsetDaylight() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.coordinate, timeZone: testLocation.timeZone)
            let sunset = try #require(testLocation.solarData.sunset)
            
            let daylight = try #require (solar.daylight)
            #expect(daylight.contains(sunset))
        }
    }
    
    @Test
    func solarAngle() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.coordinate, timeZone: testLocation.timeZone)
            
            #expect(testLocation.solarData.solarAngle == solar.angle,
                    "location: \(testLocation.name)")
        }
    }
    
    @Test
    func daylightIntervalSeconds() throws {
        let solar = try Solar.make(date: Date(timeIntervalSince1970: 1737779072), coordinate: Constant.cupertino, timeZone: TimeZone(identifier: "America/Los_Angeles")!)
        
        let daylight = try #require(solar.daylight)
        #expect(36453.0 == daylight.duration)
    }
}
