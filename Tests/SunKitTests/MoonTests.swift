//
//  Test.swift
//  SunKit
//
//  Created by Jim Newkirk on 2/11/25.
//

import CoreLocation
import SwiftAA
import Testing
@testable import SunKit

/// TODO: The test data here isn't very good, because it's shallow, and all the observations happen
/// on the same day. The test data should spread out locations,. dates, etc., as well as include
/// scenarios with no moon rise and/or no moon set.
struct MoonTests {
    var testDatum: [LocationMoonInfo] = []
    
    internal init() async throws {
        testDatum = LocationMoonInfo.load()
    }
    
    @Test func testLocationCount() async throws {
        #expect(testDatum.count == 5)
    }

    @Test
    func moonRise() async throws {
        for testData in testDatum {
            let solar = try Solar.make(date: testData.date, coordinate: testData.coordinate, timeZone: testData.timeZone!)
            
            #expect(testData.moonData.rise == solar.lunar.rise,
                    "Location: \(testData.name)")
        }
    }
    
    @Test
    func moonSet() async throws {
        for testData in testDatum {
            let solar = try Solar.make(date: testData.date, coordinate: testData.coordinate, timeZone: testData.timeZone!)
            
            #expect(testData.moonData.set == solar.lunar.set,
                    "Location: \(testData.name)")
        }
    }
    
    @Test
    func illumination() async throws {
        for testData in testDatum {
            let solar = try Solar.make(date: testData.date, coordinate: testData.coordinate, timeZone: testData.timeZone!)
            
            #expect(testData.moonData.illumination == round (solar.lunar.illumination * 10000.0) / 100.0,
                    "Location: \(testData.name)")
        }
    }
    
    @Test
    func phase() async throws {
        for testData in testDatum {
            let solar = try Solar.make(date: testData.date, coordinate: testData.coordinate, timeZone: testData.timeZone!)
            
            #expect(testData.moonData.phase == solar.lunar.phase,
                    "Location: \(testData.name)")
        }
    }
}
