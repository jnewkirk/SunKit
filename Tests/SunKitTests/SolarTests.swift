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
    var testData: [TestLocation] = []
    
    internal init() async throws {
        testData = TestLocation.load()
    }
    
    @Test func testLocationCount() async throws {
        #expect(testData.count == 246)
    }
    
    @Test
    func makeRange() async throws {
        let formatter = ISO8601DateFormatter()
        let date = try #require(formatter.date(from: "2025-01-22T07:00:00Z"))
        let coordinates = CLLocationCoordinate2D(latitude: 36.148817, longitude: -107.980578)
        
        let solars = Solar.makeRange(from: date, at: coordinates, forDays: 3)
        
        try #require(solars.count == 3)
        #expect(solars[0].dawn?.actual == formatter.date(from: "2025-01-22T14:19:35Z"))
        #expect(solars[1].dawn?.actual == formatter.date(from: "2025-01-23T14:19:04Z"))
        #expect(solars[2].dawn?.actual == formatter.date(from: "2025-01-24T14:18:31Z"))
    }
    
    @Test
    func solarNoon() async throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.coordinate)
            
            /// TODO: This should get re-generated test data using a computed solar noon from Solar using their sunrise
            /// and sunset, rather than using the Apple version (which isn't exactly the same, plus straddles days)
            let computedSolarNoon = try #require (solar.solarNoon)
            let testDataSolarNoon = try #require (testLocation.sunData.solarNoon)
            var difference = abs(testDataSolarNoon.timeIntervalSince1970 - computedSolarNoon.timeIntervalSince1970);
            if (difference > 86400) {
                difference -= 86400
            }
            
            #expect(difference < 60,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func solarNoonIsDaylight() async throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.coordinate)
            
            let daylight = try #require (solar.daylight)
            let solarNoon = try #require (solar.solarNoon)
            #expect(daylight.contains(solarNoon))
        }
    }
    
    @Test
    func beforeSunriseIsNotDaylight() async throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.coordinate)
            let sunrise = try #require(testLocation.sunData.sunrise)
            let beforeSunrise = sunrise.addingTimeInterval(-1)
            
            let daylight = try #require (solar.daylight)
            #expect(daylight.contains(beforeSunrise) == false)
        }
    }
    
    @Test
    func afterSunsetIsNotDaylight() async throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.coordinate)
            let sunset = try #require(testLocation.sunData.sunset)
            let afterSunset = sunset.addingTimeInterval(1)
            
            let daylight = try #require (solar.daylight)
            #expect(daylight.contains(afterSunset) == false)
        }
    }
    
    @Test
    func sunriseDaylight() async throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.coordinate)
            let sunrise = try #require(testLocation.sunData.sunrise)
            
            let daylight = try #require (solar.daylight)
            #expect(daylight.contains(sunrise))
        }
    }
    
    @Test
    func sunsetDaylight() async throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.coordinate)
            let sunset = try #require(testLocation.sunData.sunset)
            
            let daylight = try #require (solar.daylight)
            #expect(daylight.contains(sunset))
        }
    }
    
    @Test
    func noSunriseOccurs() {
        let solar = Solar(date: Date(timeIntervalSince1970: 1486598400), coordinate: CLLocationCoordinate2D(latitude: 78.2186, longitude: 15.64007))
        
        #expect(solar.dawn == nil)
    }
    
    
    @Test
    func noSunsetOccurs() {
        let solar = Solar(date: Date(timeIntervalSince1970: 1486598400), coordinate: CLLocationCoordinate2D(latitude: 78.2186, longitude: 15.64007))
        
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
        let solar = Solar(date: date, coordinate: coord)
        
        #expect(solar.dawn != nil)
        #expect(solar.dusk == nil)
    }
    
    @Test
    func daylightIntervalSeconds() throws {
        let solar = Solar(date: Date(timeIntervalSince1970: 1737779072), coordinate: Constant.cupertino)
        
        let daylight = try #require(solar.daylight)
        #expect(daylight.duration == 36497.0)
    }
    
    @Test(arguments: zip(
        ["2000-01-01T12:00:00Z", "1582-10-15T00:00:00Z", "1600-02-29T12:00:00Z", "1999-12-31T23:59:59Z"],
        [2451545.0,              2299160.5,              2305507.0,              2451544.499988426]))
    func julianDay(dateString: String, julianDay: Double) throws {
        #expect(julianDay == Solar.julianDay(from: dateString.toDate()!))
    }
}
