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
    
    internal init() {
        testData = TestSolarData.load()
    }
    
    @Test
    func testLocationCount() {
        #expect(testData.count == 246)
    }
    
    @Test
    func makeRange() throws {
        let formatter = ISO8601DateFormatter()
        let date = try #require(formatter.date(from: "2025-01-22T07:00:00Z"))
        let coordinates = CLLocationCoordinate2D(latitude: 36.148817, longitude: -107.980578)
        
        let solars = Solar.makeRange(from: date, at: coordinates, timeZone: TimeZone(identifier: "America/Denver")!, forDays: 3)
        
        try #require(solars.count == 3)
        #expect(formatter.date(from: "2025-01-22T14:18:00Z") == solars[0].sunrise)
        #expect(formatter.date(from: "2025-01-23T14:17:00Z") == solars[1].sunrise)
        #expect(formatter.date(from: "2025-01-24T14:17:00Z") == solars[2].sunrise)
    }
    
    @Test
    func solarNoon() {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            #expect(testLocation.solarData.solarNoon == solar.solarNoon,
                    "Test Location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func solarNoonIsDaylight() throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)

            let daylight = try #require (solar.daylight)
            let solarNoon = try #require (solar.solarNoon)
            #expect(daylight.contains(solarNoon),
                    "location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func beforeSunriseIsNotDaylight() throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            let sunrise = try #require(testLocation.solarData.sunrise)
            let beforeSunrise = sunrise.addingTimeInterval(-1)
            
            let daylight = try #require (solar.daylight)
            #expect(daylight.contains(beforeSunrise) == false,
                    "location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func afterSunsetIsNotDaylight() throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            let sunset = try #require(testLocation.solarData.sunset)
            let afterSunset = sunset.addingTimeInterval(1)
            
            let daylight = try #require (solar.daylight)
            #expect(daylight.contains(afterSunset) == false,
                    "location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func sunriseDaylight() throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            let sunrise = try #require(testLocation.solarData.sunrise)
            
            let daylight = try #require (solar.daylight)
            #expect(daylight.contains(sunrise),
                    "location: \(testLocation.waypoint.name)")
        }
    }
    
    @Test
    func sunsetDaylight() throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            let sunset = try #require(testLocation.solarData.sunset)
            
            let daylight = try #require (solar.daylight)
            #expect(daylight.contains(sunset),
                    "location: \(testLocation.waypoint.name)")
        }
    }

    @Test
    func solarAngle() {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            #expect(testLocation.solarData.solarAngle == solar.angle,
                    "location: \(testLocation.waypoint.name)")
        }
    }
  
    @Test
    func daylightIntervalSeconds() throws {
        let solar = Solar(date: Date(timeIntervalSince1970: 1737779072), coordinate: Constant.cupertino, timeZone: TimeZone(identifier: "America/Los_Angeles")!)
        
        let daylight = try #require(solar.daylight)
        #expect(36420.0 == daylight.duration)
    }
    
    @Test
    func sunsetPrecedesSunrise() {
        // Svalbard
        let solar = Solar(
            date: "2025-04-18T04:00:00Z".toDate()!,
            coordinate: CLLocationCoordinate2D(latitude: 78.22745806736931, longitude: 15.77845128961993),
            timeZone: TimeZone(identifier: "Arctic/Longyearbyen")!
        )
        
        #expect("2025-04-17T23:27:00Z".toDate() == solar.sunrise)
        #expect(nil == solar.astronomicalDawn)
        #expect(nil == solar.civilDawn)
        #expect(nil == solar.nauticalDawn)

        #expect("2025-04-17T22:20:00Z".toDate() == solar.sunset)
        #expect(nil == solar.astronomicalDusk)
        #expect(nil == solar.civilDusk)
        #expect(nil == solar.nauticalDusk)
    }
    
    struct nextSolar {
        struct sunriseBeforeSunset {
            let today: Solar
            let tomorrow: Solar
            
            init() {
                let calendar = Calendar.current
                let components = DateComponents(year: 2025, month: 1, day: 29, hour: 0, minute: 0, second: 0)
                let date = calendar.date(from: components)!
                
                let days = Solar.makeRange(from: date, at: Constant.cupertino, timeZone: Constant.pacificTimeZone)
                today = days[0]
                tomorrow = days[1]
            }
            
            @Test
            func beforeSunrise() throws {
                let sunriseToday: Date = today.sunrise!
                let timeBeforeSunrise = sunriseToday.add(hours: -1)
                
                let result = try #require (Solar.nextRiseOrSet(date: timeBeforeSunrise, coordinate: Constant.cupertino, timeZone: Constant.pacificTimeZone))
                
                #expect(result.isSunrise == true)
                #expect(result.solar.sunrise == sunriseToday)
            }
            
            @Test
            func betweenSunriseAndSunset() throws {
                let sunsetToday: Date = today.sunset!
                let timeBeforeSunset = sunsetToday.add(hours: -1)
                
                let result = try #require (Solar.nextRiseOrSet(date: timeBeforeSunset, coordinate: Constant.cupertino, timeZone: Constant.pacificTimeZone))
                
                #expect(result.isSunrise == false)
                #expect(result.solar.sunset == sunsetToday)
            }
            
            @Test
            func afterSunset() throws {
                let sunsetToday: Date = today.sunset!
                let sunriseTomorrow: Date = tomorrow.sunrise!
                let timeAfterSunset = sunsetToday.add(hours: +1)
                
                let result = try #require (Solar.nextRiseOrSet(date: timeAfterSunset, coordinate: Constant.cupertino, timeZone: Constant.pacificTimeZone))
                
                #expect(result.isSunrise == true)
                #expect(result.solar.sunrise == sunriseTomorrow)
            }
        }
        
        @Suite(.serialized)
        struct sunsetBeforeSunrise {
            let today: Solar
            let tomorrow: Solar
            
            init() {
                today = Solar(date: "2025-04-18T04:00:00Z".toDate()!, coordinate: Constant.longyearbyen, timeZone: Constant.longyearbyenTimeZone)
                tomorrow = Solar(date: "2025-04-19T04:00:00Z".toDate()!, coordinate: Constant.longyearbyen, timeZone: Constant.longyearbyenTimeZone)
            }
            
            @Test
            func beforeSunset() throws {
                let sunsetToday = today.sunset!
                let timeBeforeSunset = sunsetToday.add(hours: -1)
                
                let result = try #require (Solar.nextRiseOrSet(date: timeBeforeSunset, coordinate: Constant.longyearbyen, timeZone: Constant.longyearbyenTimeZone))

                #expect(result.isSunrise == false)
                #expect(result.solar.sunset == sunsetToday)
            }
            
            @Test
            func betweenSunsetAndSunrise() throws {
                let sunsetToday = today.sunset!
                let timeAfterSunset = sunsetToday.add(hours: +1)
                
                let result = try #require (Solar.nextRiseOrSet(date: timeAfterSunset, coordinate: Constant.longyearbyen, timeZone: Constant.longyearbyenTimeZone))

                #expect(result.isSunrise == true)
                #expect(result.solar.sunrise == today.sunrise)
            }
            
            @Test
            func afterSunrise() throws {
                let sunriseToday = today.sunrise!
                let timeAfterSunrise = sunriseToday.add(hours: +1)
                
                let result = try #require (Solar.nextRiseOrSet(date: timeAfterSunrise, coordinate: Constant.longyearbyen, timeZone: Constant.longyearbyenTimeZone))

                #expect(result.isSunrise == false)
                #expect(result.solar.sunset == tomorrow.sunset)
            }
        }
        
        @Test
        func noSunriseOrSunsetReturnsNil() {
            let result = Solar.nextRiseOrSet(date: "2025-07-18T04:00:00Z".toDate()!, coordinate: Constant.longyearbyen, timeZone: Constant.longyearbyenTimeZone)
            
            #expect(result == nil)
        }
    }
}
