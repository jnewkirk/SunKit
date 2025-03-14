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
    var testData: [TestSolarData] = []
    
    internal init() async throws {
        testData = TestSolarData.load()
    }
    
    @Test
    func sunrise() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.coordinate, timeZone: testLocation.timeZone)
            
            let dawn = try #require(solar.dawn)
            #expect(testLocation.solarData.sunrise == dawn.actual,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func astronomical() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.coordinate, timeZone: testLocation.timeZone)
            
            let dawn = try #require(solar.dawn)
            #expect(testLocation.solarData.astronomicalDawn == dawn.astronomical,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func civil() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.coordinate, timeZone: testLocation.timeZone)
            
            let dawn = try #require(solar.dawn)
            #expect(testLocation.solarData.civilDawn == dawn.civil,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func nautical() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.coordinate, timeZone: testLocation.timeZone)
            
            let dawn = try #require(solar.dawn)
            #expect(testLocation.solarData.nauticalDawn == dawn.nautical,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func blueHour() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.coordinate, timeZone: testLocation.timeZone)
            
            let dawn = try #require(solar.dawn)
            #expect(testLocation.solarData.morningBlueHour == dawn.blueHour,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func goldenHour() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.coordinate, timeZone: testLocation.timeZone)
            
            let dawn = try #require(solar.dawn)
            #expect(testLocation.solarData.morningGoldenHour == dawn.goldenHour,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func dawnInterval() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.coordinate, timeZone: testLocation.timeZone)
            
            /// TODO: Grytviken has no astronomical dawn
            if testLocation.name != "Grytviken" {
                let dawn = try #require(solar.dawn)
                
                #expect(testLocation.solarData.astronomicalDawn == dawn.interval?.start,
                        "Test Location: \(testLocation.name)")
                #expect(testLocation.solarData.morningGoldenHour?.end == dawn.interval?.end,
                        "Test Location: \(testLocation.name)")
            }
        }
    }
}
