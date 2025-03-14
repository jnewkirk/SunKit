//
//  DuskTests.swift
//  SunKit
//
//  Copyright © 2025 James Newkirk, Brad Wilson. All rights reserved.
//

import Testing
import Foundation
import CoreLocation
@testable import SunKit

struct DuskTests {
    var testData: [TestSolarData] = []
    
    internal init() async throws {
        testData = TestSolarData.load()
    }
    
    @Test
    func sunset() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            let dusk = try #require(solar.dusk, "Test Location: \(testLocation.waypoint.name), expected sunset of \(testLocation.solarData.sunset)")
            #expect(testLocation.solarData.sunset == dusk.actual,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func astronomical() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            let dusk = try #require(solar.dusk)
            #expect(testLocation.solarData.astronomicalDusk == dusk.astronomical,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func civil() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            let dusk = try #require(solar.dusk)
            #expect(testLocation.solarData.civilDusk == dusk.civil,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func nautical() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            let dusk = try #require(solar.dusk)
            #expect(testLocation.solarData.nauticalDusk == dusk.nautical,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func blueHour() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            let dusk = try #require(solar.dusk)
            #expect(testLocation.solarData.eveningBlueHour == dusk.blueHour,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func goldenHour() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            let dusk = try #require(solar.dusk)
            #expect(testLocation.solarData.eveningGoldenHour == dusk.goldenHour,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func duskInterval() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            let dusk = try #require(solar.dusk)
            #expect(testLocation.solarData.eveningGoldenHour?.start == dusk.interval?.start,
                    "Test Location: \(testLocation.waypoint.name)")
            #expect(testLocation.solarData.astronomicalDusk == dusk.interval?.end,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func noSunset() throws {
        // Svalbard
        let solar = try Solar.make(
            date: "2025-04-10T04:00:00Z".toDate()!,
            coordinate: CLLocationCoordinate2D(latitude: 78.22745806736931, longitude: 15.77845128961993),
            timeZone: TimeZone(identifier: "Arctic/Longyearbyen")!
        )
        
        #expect("2025-04-10T01:44:24Z".toDate() == solar.dawn.actual)
        #expect(nil == solar.dawn.astronomical)
        #expect(nil == solar.dawn.civil)
        #expect(nil == solar.dawn.nautical)
        
        #expect("2025-04-10T20:18:05Z".toDate() == solar.dusk.actual)
        #expect(nil == solar.dusk.astronomical)
        #expect(nil == solar.dusk.civil)
        #expect(nil == solar.dusk.nautical)
    }
}
