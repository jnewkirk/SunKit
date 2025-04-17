//
//  DawnTests.swift
//  SunKit
//
//  Copyright © 2025 James Newkirk, Brad Wilson. All rights reserved.
//

import Testing
import Foundation
import CoreLocation
@testable import SunKit

struct DawnTests {
    let testData: [TestSolarData]
    
    internal init() throws {
        testData = TestSolarData.load()
    }
    
    @Test
    func sunriseFromComputedProperty() throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            let sunrise = try #require(solar.sunrise)
            #expect(testLocation.solarData.sunrise == sunrise,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }

    @Test
    func sunriseFromGetEvent() throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            let sunrise = try #require(solar.getEvent(.sunrise))
            #expect(testLocation.solarData.sunrise == sunrise,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func sunriseFromRiseAndSet() throws {
        for testLocation in testData {
            let riseSet = Solar.riseAndSet(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            let rise = try #require(riseSet.rise)
            #expect(testLocation.solarData.sunrise == rise,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }

    @Test
    func azimuth() throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            let azimuth = try #require(solar.sunriseAzimuth)
            #expect(testLocation.solarData.sunriseAzimuth == azimuth.value,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func astronomical() throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)

            let astronomicalDawn = try #require(solar.astronomicalDawn, "Test Location: \(testLocation.waypoint.name)")
            #expect(testLocation.solarData.astronomicalDawn == astronomicalDawn,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func civil() throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)

            let civilDawn = try #require(solar.civilDawn)
            #expect(testLocation.solarData.civilDawn == civilDawn,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func nautical() throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)

            let nauticalDawn = try #require(solar.nauticalDawn)
            #expect(testLocation.solarData.nauticalDawn == nauticalDawn,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func blueHour() throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            let blueHourDawn = try #require(solar.blueHourDawn)
            #expect(testLocation.solarData.morningBlueHour == blueHourDawn,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func goldenHour() throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            let goldenHourDawn = try #require(solar.goldenHourDawn)
            #expect(testLocation.solarData.morningGoldenHour == goldenHourDawn,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func dawnInterval() throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            let interval = try #require(solar.getInterval(SolarInterval(from: .astronomicalDawn, to: .goldenHourEndDawn)))

            #expect(testLocation.solarData.astronomicalDawn == interval.start,
                    "Test Location: \(testLocation.waypoint.name)")
            #expect(testLocation.solarData.morningGoldenHour?.end == interval.end,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func noSunrise() {
        // Svalbard
        let solar = Solar(
            date: "2025-12-14T04:00:00Z".toDate()!,
            coordinate: CLLocationCoordinate2D(latitude: 78.22745806736931, longitude: 15.77845128961993),
            timeZone: TimeZone(identifier: "Arctic/Longyearbyen")!
        )
        
        #expect(nil == solar.sunrise)
        #expect("2025-12-14T06:27:00Z".toDate() == solar.astronomicalDawn)
        #expect(nil == solar.civilDawn)
        #expect("2025-12-14T09:38:00Z".toDate() == solar.nauticalDawn)
        
        #expect(nil == solar.sunset)
        #expect("2025-12-14T15:13:00Z".toDate() == solar.astronomicalDusk)
        #expect(nil == solar.civilDusk)
        #expect("2025-12-14T12:02:00Z".toDate() == solar.nauticalDusk)
    }
}
