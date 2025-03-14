//
//  SolarTests.swift
//  SunKit
//
//  Copyright © 2025 James Newkirk, Brad Wilson. All rights reserved.

import Testing
import Foundation
import CoreLocation
@testable import SunKit

struct SolarTests {
    var testData: [TestSolarData] = []
    
    internal init() async throws {
        testData = TestSolarData.load()
    }
    
    @Test
    func testLocationCount() async throws {
        #expect(testData.count == 246)
    }
    
    @Test
    func makeRange() async throws {
        let formatter = ISO8601DateFormatter()
        let date = try #require(formatter.date(from: "2025-01-22T07:00:00Z"))
        let coordinates = CLLocationCoordinate2D(latitude: 36.148817, longitude: -107.980578)
        
        let solars = try Solar.makeRange(from: date, at: coordinates, timeZone: TimeZone(identifier: "America/Denver")!, forDays: 3)
        
        try #require(solars.count == 3)
        #expect(formatter.date(from: "2025-01-22T14:17:58Z") == solars[0].dawn?.actual)
        #expect(formatter.date(from: "2025-01-23T14:17:25Z") == solars[1].dawn?.actual)
        #expect(formatter.date(from: "2025-01-24T14:16:52Z") == solars[2].dawn?.actual)
    }
    
    @Test
    func solarNoon() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.coordinate, timeZone: testLocation.timeZone)
            
            #expect(testLocation.solarData.solarNoon == solar.solarNoon,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func solarNoonIsDaylight() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.coordinate, timeZone: testLocation.timeZone)

            let daylight = try #require (solar.daylight)
            let solarNoon = try #require (solar.solarNoon)
            #expect(daylight.contains(solarNoon))
        }
    }
    
    @Test
    func beforeSunriseIsNotDaylight() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.coordinate, timeZone: testLocation.timeZone)
            let sunrise = try #require(testLocation.solarData.sunrise)
            let beforeSunrise = sunrise.addingTimeInterval(-1)
            
            let daylight = try #require (solar.daylight)
            #expect(daylight.contains(beforeSunrise) == false)
        }
    }
    
    @Test
    func afterSunsetIsNotDaylight() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.coordinate, timeZone: testLocation.timeZone)
            let sunset = try #require(testLocation.solarData.sunset)
            let afterSunset = sunset.addingTimeInterval(1)
            
            let daylight = try #require (solar.daylight)
            #expect(daylight.contains(afterSunset) == false)
        }
    }
    
    @Test
    func sunriseDaylight() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.coordinate, timeZone: testLocation.timeZone)
            let sunrise = try #require(testLocation.solarData.sunrise)
            
            let daylight = try #require (solar.daylight)
            #expect(daylight.contains(sunrise))
        }
    }
    
    @Test
    func sunsetDaylight() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.coordinate, timeZone: testLocation.timeZone)
            let sunset = try #require(testLocation.solarData.sunset)
            
            let daylight = try #require (solar.daylight)
            #expect(daylight.contains(sunset))
        }
    }
    
    @Test
    func solarAngle() async throws {
        for testLocation in testData {
            let solar = try Solar.make(date: testLocation.date, coordinate: testLocation.coordinate, timeZone: testLocation.timeZone)
            
            #expect(testLocation.solarData.solarAngle == solar.solarAngle,
                    "location: \(testLocation.name)")
        }
    }
    
    @Test
    func noSunriseOccurs() throws {
        let solar = try Solar.make(date: Date(timeIntervalSince1970: 1486598400),
                          coordinate: CLLocationCoordinate2D(latitude: 78.2186, longitude: 15.64007),
                          timeZone: TimeZone(identifier: "Arctic/Longyearbyen")!)
        
        #expect(solar.dawn == nil)
    }
    
    
    @Test
    func noSunsetOccurs() throws {
        let solar = try Solar.make(date: Date(timeIntervalSince1970: 1486598400),
                          coordinate: CLLocationCoordinate2D(latitude: 78.2186, longitude: 15.64007),
                          timeZone: TimeZone(identifier: "Arctic/Longyearbyen")!)
        
        #expect(solar.dusk == nil)
    }
    
    @Test(.disabled())
    func sunriseWithoutSunset() async throws {
        // Based on web information, we have a very unusual circumstance.
        // If you assume that "sunset always follows sunrise", on this date in Svalbard,
        // the sunset actually happens at 12:31am the following day. So should that be
        // included as the sunset on the 18th or the 19th?
        // Similarly, the sun rises on the 19th but never sets. How should that be represented?
        // Logically, do we always want to pair the sunrise and sunset together based on logical
        // interpretation or based on the strict calendar? And if the sunset is 3.5 months away,
        // should we give back a sunset 3.5 months in the future when you ask for April 19th?
        // On top of all this, we definitely have bugs here. :-D
        // Another question: if we say "yes" to sunset 3.5 months from now, what about when we ask
        // for April 20th? Shound the sunrise be the one from April 19th in addition to the sunset
        // in 3.5 months? (i.e., do we go backwards in addition to forwards)
        // Ditto everything here for moonrise/moonset

        // Svalbard
        let coord = CLLocationCoordinate2D(latitude: 16.169450495664844, longitude: 78.61349702286212)
        let date = "2025-04-18T12:00:00Z".toDate()!
        let solar = try Solar.make(date: date, coordinate: coord, timeZone: TimeZone(identifier: "Arctic/Longyearbyen")!)
        
        #expect(solar.dawn != nil)
        #expect(solar.dusk == nil)
    }
    
    @Test
    func daylightIntervalSeconds() throws {
        let solar = try Solar.make(date: Date(timeIntervalSince1970: 1737779072), coordinate: Constant.cupertino, timeZone: TimeZone(identifier: "America/Los_Angeles")!)
        
        let daylight = try #require(solar.daylight)
        #expect(36453.0 == daylight.duration)
    }
}
