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
    func makeRangeOld() throws {
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
    
    struct makeRange {
        @Test
        func oneDay() throws {
            let formatter = ISO8601DateFormatter()
            let date = try #require(formatter.date(from: "2025-01-22T06:00:00Z"))
            let interval = DateInterval(start: date, duration: 24 * 60 * 60)
            let coordinates = Constant.alienThrone

            let solunarEvents = Solar.makeRange(interval: interval, at: coordinates, events: Set(SolunarEventKind.allCases))

            try #require(solunarEvents.count == 12)

            #expect(formatter.date(from: "2025-01-22T12:49:00Z") == solunarEvents[0].date)
            #expect(SolunarEventKind.astronomicalDawn == solunarEvents[0].kind)

            #expect(formatter.date(from: "2025-01-22T13:19:00Z") == solunarEvents[1].date)
            #expect(SolunarEventKind.nauticalDawn == solunarEvents[1].kind)

            #expect(formatter.date(from: "2025-01-22T13:50:00Z") == solunarEvents[2].date)
            #expect(SolunarEventKind.civilDawn == solunarEvents[2].kind)

            #expect(formatter.date(from: "2025-01-22T14:01:00Z") == solunarEvents[3].date)
            #expect(SolunarEventKind.blueHourDawnEnd == solunarEvents[3].kind)

            #expect(formatter.date(from: "2025-01-22T14:18:00Z") == solunarEvents[4].date)
            #expect(SolunarEventKind.sunrise == solunarEvents[4].kind)
            #expect(114 == solunarEvents[4].azimuth.value.rounded())

            #expect(formatter.date(from: "2025-01-22T14:56:00Z") == solunarEvents[5].date)
            #expect(SolunarEventKind.goldenHourDawnEnd == solunarEvents[5].kind)

            #expect(formatter.date(from: "2025-01-22T23:49:00Z") == solunarEvents[6].date)
            #expect(SolunarEventKind.goldenHourDuskStart == solunarEvents[6].kind)

            #expect(formatter.date(from: "2025-01-23T00:27:00Z") == solunarEvents[7].date)
            #expect(SolunarEventKind.sunset == solunarEvents[7].kind)
            #expect(246 == solunarEvents[7].azimuth.value.rounded())

            #expect(formatter.date(from: "2025-01-23T00:44:00Z") == solunarEvents[8].date)
            #expect(SolunarEventKind.blueHourDuskStart == solunarEvents[8].kind)

            #expect(formatter.date(from: "2025-01-23T00:55:00Z") == solunarEvents[9].date)
            #expect(SolunarEventKind.civilDusk == solunarEvents[9].kind)

            #expect(formatter.date(from: "2025-01-23T01:26:00Z") == solunarEvents[10].date)
            #expect(SolunarEventKind.nauticalDusk == solunarEvents[10].kind)

            #expect(formatter.date(from: "2025-01-23T01:57:00Z") == solunarEvents[11].date)
            #expect(SolunarEventKind.astronomicalDusk == solunarEvents[11].kind)
        }
        
        @Test
        func threeDays() throws {
            let formatter = ISO8601DateFormatter()
            let date = try #require(formatter.date(from: "2025-01-22T19:00:00Z"))
            let interval = DateInterval(start: date, duration: 3 * 24 * 60 * 60)
            let coordinates = Constant.alienThrone
            
            let solunarEvents = Solar.makeRange(interval: interval, at: coordinates, events: [.sunrise, .sunset])
            
            try #require(solunarEvents.count == 6)
            
            #expect(formatter.date(from: "2025-01-23T00:27:00Z") == solunarEvents[0].date)
            #expect(SolunarEventKind.sunset == solunarEvents[0].kind)
            
            #expect(formatter.date(from: "2025-01-23T14:17:00Z") == solunarEvents[1].date)
            #expect(SolunarEventKind.sunrise == solunarEvents[1].kind)
            
            #expect(formatter.date(from: "2025-01-24T00:28:00Z") == solunarEvents[2].date)
            #expect(SolunarEventKind.sunset == solunarEvents[2].kind)
            
            #expect(formatter.date(from: "2025-01-24T14:17:00Z") == solunarEvents[3].date)
            #expect(SolunarEventKind.sunrise == solunarEvents[3].kind)
            
            #expect(formatter.date(from: "2025-01-25T00:29:00Z") == solunarEvents[4].date)
            #expect(SolunarEventKind.sunset == solunarEvents[4].kind)
            
            #expect(formatter.date(from: "2025-01-25T14:16:00Z") == solunarEvents[5].date)
            #expect(SolunarEventKind.sunrise == solunarEvents[5].kind)
        }
    }
}
