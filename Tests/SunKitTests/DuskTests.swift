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
    func sunset() throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            let sunset = try #require(solar.sunset, "Test Location: \(testLocation.waypoint.name), expected sunset of \(testLocation.solarData.sunset?.formatted() ?? "no sunset")")
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
            
            let blueHourDuskStart = try #require(solar.blueHourDuskStart)
            #expect(testLocation.solarData.eveningBlueHourStart == blueHourDuskStart,
                    "Test Location: \(testLocation.waypoint.name)")

            let blueHourDuskEnd = try #require(solar.blueHourDuskEnd)
            #expect(testLocation.solarData.eveningBlueHourEnd == blueHourDuskEnd,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func goldenHour() throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            let goldenHourDuskStart = try #require(solar.goldenHourDuskStart)
            #expect(testLocation.solarData.eveningGoldenHourStart == goldenHourDuskStart,
                    "Test Location: \(testLocation.waypoint.name)")

            let goldenHourDuskEnd = try #require(solar.goldenHourDuskEnd)
            #expect(testLocation.solarData.eveningGoldenHourEnd == goldenHourDuskEnd,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func noSunset() throws {
        let solar = Solar(
            date: "2025-04-19T04:00:00Z".toDate()!,
            coordinate: Constant.longyearbyen,
            timeZone: Constant.longyearbyenTimeZone
        )
        
        #expect(nil == solar.sunset)
        #expect(nil == solar.astronomicalDusk)
        #expect(nil == solar.civilDusk)
        #expect(nil == solar.nauticalDusk)
    }
    
    @Test
    func endOfCivilDuskHappensOnNextDay() throws {
        // Testing both the 17th and 18th, because the civil dusk of the 17th rolls into the 18th,
        // and the civil dusk of the 18th rolls into the 19th
        let solar17 = Solar(
            date: "2025-05-17T08:00:00Z".toDate()!,
            coordinate: Constant.anchorage,
            timeZone: Constant.alaskaTimeZone!
        )
        
        #expect("2025-05-18T05:34:00Z".toDate() == solar17.goldenHourDuskStart)
        #expect("2025-05-18T06:47:00Z".toDate() == solar17.sunset)
        #expect("2025-05-18T07:29:00Z".toDate() == solar17.blueHourDuskStart)
        #expect("2025-05-18T08:01:00Z".toDate() == solar17.civilDusk)
        #expect(nil == solar17.nauticalDusk)
        #expect(nil == solar17.astronomicalDusk)

        let solar18 = Solar(
            date: "2025-05-18T08:00:00Z".toDate()!,
            coordinate: Constant.anchorage,
            timeZone: Constant.alaskaTimeZone!
        )
        
        #expect("2025-05-19T05:36:00Z".toDate() == solar18.goldenHourDuskStart)
        #expect("2025-05-19T06:49:00Z".toDate() == solar18.sunset)
        #expect("2025-05-19T07:32:00Z".toDate() == solar18.blueHourDuskStart)
        #expect("2025-05-19T08:05:00Z".toDate() == solar18.civilDusk)
        #expect(nil == solar18.nauticalDusk)
        #expect(nil == solar18.astronomicalDusk)
    }
}
