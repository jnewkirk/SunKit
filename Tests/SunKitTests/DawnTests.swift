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
    func sunrise() throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            let sunrise = try #require(solar.sunrise)
            #expect(testLocation.solarData.sunrise == sunrise,
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
            
            let blueHourDawnStart = try #require(solar.blueHourDawnStart)
            #expect(testLocation.solarData.morningBlueHourStart == blueHourDawnStart,
                    "Test Location: \(testLocation.waypoint.name)")
            
            let blueHourDawnEnd = try #require(solar.blueHourDawnEnd)
            #expect(testLocation.solarData.morningBlueHourEnd == blueHourDawnEnd,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func goldenHour() throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            let goldenHourDawnStart = try #require(solar.goldenHourDawnStart)
            #expect(testLocation.solarData.morningGoldenHourStart == goldenHourDawnStart,
                    "Test Location: \(testLocation.waypoint.name)")
            
            let goldenHourDawnEnd = try #require(solar.goldenHourDawnEnd)
            #expect(testLocation.solarData.morningGoldenHourEnd == goldenHourDawnEnd,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func noSunrise() {
        let solar = Solar(
            date: "2025-12-14T04:00:00Z".toDate()!,
            coordinate: Constant.longyearbyen,
            timeZone: Constant.longyearbyenTimeZone
        )
        
        #expect("2025-12-14T06:28:00Z".toDate() == solar.astronomicalDawn)
        #expect("2025-12-14T09:38:00Z".toDate() == solar.nauticalDawn)
        #expect(nil == solar.civilDawn)
        #expect(nil == solar.sunrise)
    }
    
    @Test
    func civilDawnStartsTheDayBefore() throws {
        let solar = Solar(
            date: "2025-07-10T08:00:00Z".toDate()!,
            coordinate: Constant.anchorage,
            timeZone: Constant.alaskaTimeZone!
        )
        
        #expect(nil == solar.astronomicalDawn)
        #expect(nil == solar.nauticalDawn)
        #expect("2025-07-10T10:54:00Z".toDate() == solar.civilDawn)
        #expect("2025-07-10T11:48:00Z".toDate() == solar.blueHourDawnEnd)
        #expect("2025-07-10T12:41:00Z".toDate() == solar.sunrise)
        #expect("2025-07-10T14:02:00Z".toDate() == solar.goldenHourDawnEnd)
    }
}
