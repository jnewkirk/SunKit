//
//  Test.swift
//  SunKit
//
//  Created by Jim Newkirk on 2/11/25.
//

import Testing
@testable import SunKit

struct MoonTests {
    var testDatum: [LocationMoonInfo] = []
    
    internal init() async throws {
        testDatum = LocationMoonInfo.load()
    }
    
    @Test func testLocationCount() async throws {
        #expect(testDatum.count == 5)
    }
    
    @Test
    func lunarPhase() async throws {
        for testData in testDatum {
            let solar = Solar(date: testData.date, coordinate: testData.coordinate)
            
            #expect(solar.lunar.phase == testData.moonData.phase,
                    "Test Location: \(testData.name)")
        }
    }
    
    @Test
    func illumination() async throws {
        for testData in testDatum {
            let solar = Solar(date: testData.date, coordinate: testData.coordinate)
            
            #expect(solar.lunar.illumination == testData.moonData.illumination,
                    "Test Location: \(testData.name)")
        }
    }
    
    @Test(arguments: zip(
        [2451549.5, 2451551.5, 2451556.9, 2451564.3, 2451579.3],
        [0.0,       2.0,       7.4,       14.8,      0.3]
    ))
    func moonAge(julianDate: Double, moonAge: Double) throws {
        #expect(moonAge == Solar.moonAge(julianDate: julianDate))
    }
    
    @Test(arguments: zip(
        [2.0,                       11.5,                     18.2,                     25.1],
        [LunarPhase.waxingCrescent, LunarPhase.waxingGibbous, LunarPhase.waningGibbous, LunarPhase.waningCrescent]
    ))
    func lunarPhaseByAge(moonAge: Double, moonPhase: LunarPhase) throws {
        #expect(moonPhase == Solar.lunarPhase(moonAge: moonAge))
    }
}
