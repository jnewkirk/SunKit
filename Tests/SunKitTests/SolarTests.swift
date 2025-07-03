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
        let date = try #require(formatter.date(from: "2025-01-22T19:00:00Z"))
        let coordinates = Constant.alienThrone
        
        let solars = Solar.makeRange(from: date, at: coordinates, timeZone: Constant.mountainTimeZone, forDays: 3)
        
        try #require(solars.count == 3)

        #expect(formatter.date(from: "2025-01-22T14:18:00Z") == solars[0].sunrise)
        #expect(formatter.date(from: "2025-01-23T14:17:00Z") == solars[1].sunrise)
        #expect(formatter.date(from: "2025-01-24T14:17:00Z") == solars[2].sunrise)

        #expect(formatter.date(from: "2025-01-23T00:27:00Z") == solars[0].sunset)
        #expect(formatter.date(from: "2025-01-24T00:28:00Z") == solars[1].sunset)
        #expect(formatter.date(from: "2025-01-25T00:29:00Z") == solars[2].sunset)
        
        // Angles based on midnight, not the current time
        #expect(-72.66.rounded(toIncrement: 0.01) == solars[0].angle.rounded(toIncrement: 0.01))
        #expect(-72.42.rounded(toIncrement: 0.01) == solars[1].angle.rounded(toIncrement: 0.01))
        #expect(-72.18.rounded(toIncrement: 0.01) == solars[2].angle.rounded(toIncrement: 0.01))
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
    func solarAngle() {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.waypoint.coordinate, timeZone: testLocation.waypoint.timeZone)
            
            #expect(testLocation.solarData.solarAngle == solar.angle,
                    "location: \(testLocation.waypoint.name)")
        }
    }
  
    @Test
    func sunsetHappensInTheNextDay() {
        let solar = Solar(
            date: "2025-04-17T04:00:00Z".toDate()!,
            coordinate: Constant.longyearbyen,
            timeZone: Constant.longyearbyenTimeZone
        )
        
        #expect("2025-04-17T00:01:00Z".toDate() == solar.sunrise)  // 2:01am local time
        #expect(nil == solar.astronomicalDawn)
        #expect(nil == solar.civilDawn)
        #expect(nil == solar.nauticalDawn)

        #expect("2025-04-17T22:20:00Z".toDate() == solar.sunset)  // 12:20am local time the following day
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
        
        @Test
        func noSunriseOrSunsetReturnsNil() {
            let result = Solar.nextRiseOrSet(date: "2025-07-18T04:00:00Z".toDate()!, coordinate: Constant.longyearbyen, timeZone: Constant.longyearbyenTimeZone)
            
            #expect(result == nil)
        }
    }
}
