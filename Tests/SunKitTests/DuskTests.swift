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
    var testData: [TestLocation] = []
    
    internal init() async throws {
        testData = TestLocation.load()
    }
    
    @Test
    func sunset() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.coordinate, timeZone: testLocation.timeZone!)
            
            let dusk = try #require(solar.dusk, "Test Location: \(testLocation.name), expected sunset of \(testLocation.sunData.sunset)")
            #expect(testLocation.sunData.sunset == dusk.actual,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func astronomical() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.coordinate, timeZone: testLocation.timeZone!)
            
            let dusk = try #require(solar.dusk)
            #expect(testLocation.sunData.astronomicalDusk == dusk.astronomical,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func civil() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.coordinate, timeZone: testLocation.timeZone!)
            
            let dusk = try #require(solar.dusk)
            #expect(testLocation.sunData.civilDusk == dusk.civil,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func nautical() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.coordinate, timeZone: testLocation.timeZone!)
            
            let dusk = try #require(solar.dusk)
            #expect(testLocation.sunData.nauticalDusk == dusk.nautical,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func blueHour() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.coordinate, timeZone: testLocation.timeZone!)
            
            let dusk = try #require(solar.dusk)
            #expect(testLocation.sunData.eveningBlueHour == dusk.blueHour,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func goldenHour() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.coordinate, timeZone: testLocation.timeZone!)
            
            let dusk = try #require(solar.dusk)
            #expect(testLocation.sunData.eveningGoldenHour == dusk.goldenHour,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func duskInterval() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.coordinate, timeZone: testLocation.timeZone!)
            
            /// TODO: Grytviken has no astronomical dawn
            if testLocation.name != "Grytviken" {
                let dusk = try #require(solar.dusk)
                #expect(testLocation.sunData.eveningGoldenHour?.start == dusk.interval?.start,
                        "Test Location: \(testLocation.name)")
                #expect(testLocation.sunData.astronomicalDusk == dusk.interval?.end,
                        "Test Location: \(testLocation.name)")
            }
        }
    }
}
