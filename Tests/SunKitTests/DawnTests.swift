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
    func sunriseFromMake() throws {
        for testLocation in testData {
            let solar = Solar.make(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            let dawn = try #require(solar.dawn)
            #expect(testLocation.solarData.sunrise == dawn.actual,
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
            let solar = Solar.make(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            let azimuth = try #require(solar.dawn.actualAzimuth)
            #expect(testLocation.solarData.sunriseAzimuth == azimuth.value,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func astronomical() throws {
        for testLocation in testData {
            let solar = Solar.make(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            let dawn = try #require(solar.dawn)
            #expect(testLocation.solarData.astronomicalDawn == dawn.astronomical,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func civil() throws {
        for testLocation in testData {
            let solar = Solar.make(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            let dawn = try #require(solar.dawn)
            #expect(testLocation.solarData.civilDawn == dawn.civil,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func nautical() throws {
        for testLocation in testData {
            let solar = Solar.make(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            let dawn = try #require(solar.dawn)
            #expect(testLocation.solarData.nauticalDawn == dawn.nautical,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func blueHour() throws {
        for testLocation in testData {
            let solar = Solar.make(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            let dawn = try #require(solar.dawn)
            #expect(testLocation.solarData.morningBlueHour == dawn.blueHour,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func goldenHour() throws {
        for testLocation in testData {
            let solar = Solar.make(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            let dawn = try #require(solar.dawn)
            #expect(testLocation.solarData.morningGoldenHour == dawn.goldenHour,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func dawnInterval() throws {
        for testLocation in testData {
            let solar = Solar.make(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            let dawn = try #require(solar.dawn)
            
            #expect(testLocation.solarData.astronomicalDawn == dawn.interval?.start,
                    "Test Location: \(testLocation.waypoint.name)")
            #expect(testLocation.solarData.morningGoldenHour?.end == dawn.interval?.end,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func noSunrise() {
        // Svalbard
        let solar = Solar.make(
            date: "2025-12-14T04:00:00Z".toDate()!,
            coordinate: CLLocationCoordinate2D(latitude: 78.22745806736931, longitude: 15.77845128961993),
            timeZone: TimeZone(identifier: "Arctic/Longyearbyen")!
        )
        
        #expect(nil == solar.dawn.actual)
        #expect("2025-12-14T06:27:00Z".toDate() == solar.dawn.astronomical)
        #expect(nil == solar.dawn.civil)
        #expect("2025-12-14T09:38:00Z".toDate() == solar.dawn.nautical)
        
        #expect(nil == solar.dusk.actual)
        #expect("2025-12-14T15:13:00Z".toDate() == solar.dusk.astronomical)
        #expect(nil == solar.dusk.civil)
        #expect("2025-12-14T12:02:00Z".toDate() == solar.dusk.nautical)
    }
}
