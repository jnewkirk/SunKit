//
//  SolarTests.swift
//  SunKit
//
//  Created by Jim Newkirk on 1/29/25.
//

import Testing
import Foundation
import CoreLocation
@testable import SunKit

struct SolarTests {
    var testData: [TestLocation] = []
    
    internal init() async throws {
        testData = TestLocation.load()
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
            let testDataSolarNoon = try #require (testLocation.sunModel.solarNoon)
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
            let sunrise = try #require(testLocation.sunModel.sunrise)
            let beforeSunrise = sunrise.addingTimeInterval(-1)
            
            let daylight = try #require (solar.daylight)
            #expect(daylight.contains(beforeSunrise) == false)
        }
    }
    
    @Test
    func afterSunsetIsNotDaylight() async throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.coordinate)
            let sunset = try #require(testLocation.sunModel.sunset)
            let afterSunset = sunset.addingTimeInterval(1)
            
            let daylight = try #require (solar.daylight)
            #expect(daylight.contains(afterSunset) == false)
        }
    }
    
    @Test
    func sunriseDaylight() async throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.coordinate)
            let sunrise = try #require(testLocation.sunModel.sunrise)
            
            let daylight = try #require (solar.daylight)
            #expect(daylight.contains(sunrise))
        }
    }
    
    @Test
    func sunsetDaylight() async throws {
        for testLocation in testData {
            let solar = Solar(date: testLocation.date, coordinate: testLocation.coordinate)
            let sunset = try #require(testLocation.sunModel.sunset)
            
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
    
    @Test
    func daylightIntervalSeconds() throws {
        let solar = Solar(date: Date(timeIntervalSince1970: 1737779072), coordinate: Constant.Cupertino)

        let daylight = try #require(solar.daylight)
        #expect(daylight.duration == 36497.0)
    }
    
    @Test(.disabled())
    func nextSolarEvents() async throws {
        let now = Date.now.addingTimeInterval(60 * 60 * 2)
        let nextSolarEvent = try #require(now.nextSolarEvents(coordinate: Constant.Cupertino))

        #expect(nextSolarEvent.isSunrise)
        debugPrint(nextSolarEvent.events.actual)
    }
}

private extension Date {
    static var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = Date.utcTimezone
        
        return calendar
    }

    static let utcTimezone = TimeZone(identifier: "UTC")!

    func midnightLocal(timeZone: TimeZone = .current) -> Date {
        let nowComponents = Date.calendar.dateComponents(in: timeZone, from: self)
        let midnightComponents = DateComponents(timeZone: timeZone, year: nowComponents.year, month: nowComponents.month, day: nowComponents.day, hour: 0, minute: 0, second: 0)
        return Date.calendar.date(from: midnightComponents)!
    }
    
    func nextSolarEvents(coordinate: CLLocationCoordinate2D, timeZone: TimeZone = .current) -> (isSunrise: Bool, events: SolarEvents)? {
        let midnightLocal = midnightLocal(timeZone: timeZone)
        
        let todayAndTomorrow = Solar.makeRange(from: midnightLocal, at: coordinate, forDays: 2)
        guard let todayDawn = todayAndTomorrow[0].dawn else { return nil }
        guard let todayDusk = todayAndTomorrow[0].dusk else { return nil }
        guard let tomorrowDawn = todayAndTomorrow[1].dawn else { return nil }
        
        if (self < todayDawn.actual) {
            return (isSunrise: true, todayDawn)
        } else if (self < todayDusk.actual) {
            return (isSunrise: false, todayDusk)
        } else {
            return (isSunrise: true, tomorrowDawn)
        }
    }
}
