//
//  DuskTests.swift
//  SunKit
//
//  Created by Jim Newkirk on 1/29/25.
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
            let solar = Solar(date: testLocation.date, coordinate: testLocation.coordinate)
            
            let dusk = try #require(solar.dusk)
            #expect(testLocation.sunModel.sunset == dusk.actual,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func astronomical() async throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.coordinate)
            
            let dusk = try #require(solar.dusk)
            #expect(testLocation.sunModel.astronomicalDusk == dusk.astronomical,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func civil() async throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.coordinate)
            
            let dusk = try #require(solar.dusk)
            #expect(testLocation.sunModel.civilDusk == dusk.civil,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func nautical() async throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.coordinate)
            
            let dusk = try #require(solar.dusk)
            #expect(testLocation.sunModel.nauticalDusk == dusk.nautical,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func blueHour() async throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.coordinate)
            
            let dusk = try #require(solar.dusk)
            #expect(testLocation.sunModel.eveningBlueHour == dusk.blueHour,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func goldenHour() async throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.coordinate)
            
            let dusk = try #require(solar.dusk)
            #expect(testLocation.sunModel.eveningGoldenHour == dusk.goldenHour,
                    "Test Location: \(testLocation.name)")
            #expect(testLocation.sunModel.eveningGoldenHour?.start == dusk.goldenHour?.start,
                    "Test Location: \(testLocation.name)")
            #expect(testLocation.sunModel.eveningGoldenHour?.end == dusk.goldenHour?.end,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func duskInterval() async throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.coordinate)
            
            /// TODO: Grytviken has no astronomical dawn
            if testLocation.name != "Grytviken" {
                let dusk = try #require(solar.dusk)
                #expect(testLocation.sunModel.eveningGoldenHour?.start == dusk.interval?.start,
                        "Test Location: \(testLocation.name)")
                #expect(testLocation.sunModel.astronomicalDusk == dusk.interval?.end,
                        "Test Location: \(testLocation.name)")
            }
        }
    }
}
