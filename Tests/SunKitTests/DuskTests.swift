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
    let testData: [TestSolarData]
    
    internal init() {
        testData = TestSolarData.load()
    }
    
    @Test
    func sunsetFromComputedProperty() throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            let sunset = try #require(solar.sunset, "Test Location: \(testLocation.waypoint.name), expected sunset of \(testLocation.solarData.sunset?.formatted() ?? "no sunset")")
            #expect(testLocation.solarData.sunset == sunset,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func sunsetFromGetEvent() throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            let sunset = try #require(solar.getEvent(.sunset), "Test Location: \(testLocation.waypoint.name), expected sunset of \(testLocation.solarData.sunset?.formatted() ?? "no sunset")")
            #expect(testLocation.solarData.sunset == sunset,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }

    @Test
    func sunsetFromRiseAndSet() throws {
        for testLocation in testData {
            let riseSet = Solar.riseAndSet(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            let sunset = try #require(riseSet.set, "Test Location: \(testLocation.waypoint.name), expected sunset of \(testLocation.solarData.sunset?.formatted() ?? "no sunset")")
            #expect(testLocation.solarData.sunset == sunset,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }

    @Test
    func azimuth() throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            let azimuth = try #require(solar.sunsetAzimuth)
            #expect(testLocation.solarData.sunsetAzimuth == azimuth.value,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }

    @Test
    func astronomical() throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)

            let astronomicalDusk = try #require(solar.astronomicalDusk)
            #expect(testLocation.solarData.astronomicalDusk == astronomicalDusk,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func civil() throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)

            let civilDusk = try #require(solar.civilDusk)
            #expect(testLocation.solarData.civilDusk == civilDusk,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func nautical() throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)

            let nauticalDusk = try #require(solar.nauticalDusk)
            #expect(testLocation.solarData.nauticalDusk == nauticalDusk,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func blueHour() throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            let blueHourDusk = try #require(solar.blueHourDusk)
            #expect(testLocation.solarData.eveningBlueHour == blueHourDusk,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func goldenHour() throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            let goldenHourDusk = try #require(solar.goldenHourDusk)
            #expect(testLocation.solarData.eveningGoldenHour == goldenHourDusk,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func duskInterval() throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            let interval = try #require(solar.getInterval(SolarInterval(from: .goldenHourStartDusk, to: .astronomicalDusk)))
            
            #expect(testLocation.solarData.eveningGoldenHour?.start == interval.start,
                    "Test Location: \(testLocation.waypoint.name)")
            #expect(testLocation.solarData.astronomicalDusk == interval.end,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }

    @Test
    func noSunset() throws {
        // Svalbard
        let solar = Solar(
            date: "2025-04-10T04:00:00Z".toDate()!,
            coordinate: CLLocationCoordinate2D(latitude: 78.22745806736931, longitude: 15.77845128961993),
            timeZone: TimeZone(identifier: "Arctic/Longyearbyen")!
        )
        
        #expect("2025-04-10T01:44:00Z".toDate() == solar.sunrise)
        #expect(nil == solar.astronomicalDawn)
        #expect(nil == solar.civilDawn)
        #expect(nil == solar.nauticalDawn)
        
        #expect("2025-04-10T20:18:00Z".toDate() == solar.sunset)
        #expect(nil == solar.astronomicalDusk)
        #expect(nil == solar.civilDusk)
        #expect(nil == solar.nauticalDusk)
    }
}
