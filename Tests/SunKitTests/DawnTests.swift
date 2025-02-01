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
    var testData: [TestLocation] = []
    
    internal init() async throws {
        testData = TestLocation.load()
    }
    
    @Test
    func sunrise() async throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.coordinate)
            
            let dawn = try #require(solar.dawn)
            #expect(testLocation.sunData.sunrise == dawn.actual,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func astronomical() async throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.coordinate)
            
            let dawn = try #require(solar.dawn)
            #expect(testLocation.sunData.astronomicalDawn == dawn.astronomical,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func civil() async throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.coordinate)
            
            let dawn = try #require(solar.dawn)
            #expect(testLocation.sunData.civilDawn == dawn.civil,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func nautical() async throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.coordinate)
            
            let dawn = try #require(solar.dawn)
            #expect(testLocation.sunData.nauticalDawn == dawn.nautical,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func blueHour() async throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.coordinate)
            
            let dawn = try #require(solar.dawn)
            #expect(testLocation.sunData.morningBlueHour == dawn.blueHour,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func goldenHour() async throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.coordinate)
            
            let dawn = try #require(solar.dawn)
            #expect(testLocation.sunData.morningGoldenHour == dawn.goldenHour,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func dawnInterval() async throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.coordinate)
            
            /// TODO: Grytviken has no astronomical dawn
            if testLocation.name != "Grytviken" {
                let dawn = try #require(solar.dawn)
                
                #expect(testLocation.sunData.astronomicalDawn == dawn.interval?.start,
                        "Test Location: \(testLocation.name)")
                #expect(testLocation.sunData.morningGoldenHour?.end == dawn.interval?.end,
                        "Test Location: \(testLocation.name)")
            }
        }
    }
}
