//
//  Solar.swift
//  SunKit
//
//  Copyright © 2025 James Newkirk, Brad Wilson. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftAA

public class Solar {
    // TODO: Iterable for Solar => Solar? Iterable for RiseOrSet => RiseOrSet?
    public init(date: Date = Date.now, coordinate: CLLocationCoordinate2D, timeZone: TimeZone) {
        self.date = date
        self.julianDay = JulianDay(date)
        self.coordinates = GeographicCoordinates(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
        self.today = DateInterval(start: date.midnightLocal(timeZone: timeZone), duration: 60 * 60 * 24)
    }

    let date: Date
    let julianDay: JulianDay
    let coordinates: GeographicCoordinates
    let today: DateInterval

    private var cache: Dictionary<Int, RiseSet> = [:]

    public var sunrise: Date? { return getEvent(.sunrise) }
    public var sunriseAzimuth: Measurement<UnitAngle>? { computeAzimuth(date: sunrise) }
    public var sunset: Date? { return getEvent(.sunset) }
    public var sunsetAzimuth: Measurement<UnitAngle>? { computeAzimuth(date: sunset) }
    public var civilDawn: Date? { return getEvent(.civilDawn) }
    public var civilDusk: Date? { return getEvent(.civilDusk) }
    public var nauticalDawn: Date? { return getEvent(.nauticalDawn) }
    public var nauticalDusk: Date? { return getEvent(.nauticalDusk) }
    public var astronomicalDawn: Date? { return getEvent(.astronomicalDawn) }
    public var astronomicalDusk: Date? { return getEvent(.astronomicalDusk) }
    public var solarNoon: Date? {
        guard let sunrise, let sunset else { return nil }
        return Date(timeIntervalSince1970: (sunrise.timeIntervalSince1970 + ((sunset.timeIntervalSince1970 - sunrise.timeIntervalSince1970) / 2))).toNearestMinute()
    }
    public var angle: Double {
        let sun = Sun(julianDay: julianDay)
        let equatorialCoordinates = sun.equatorialCoordinates
        let horizontalCoordinates = equatorialCoordinates.makeHorizontalCoordinates(for: coordinates, at: julianDay)
        
        return horizontalCoordinates.altitude.value
    }
    public var blueHourDawn: DateInterval? { getInterval(.blueHourDawn) }
    public var blueHourDusk: DateInterval? { getInterval(.blueHourDusk) }
    public var goldenHourDawn: DateInterval? { getInterval(.goldenHourDawn) }
    public var goldenHourDusk: DateInterval? { getInterval(.goldenHourDusk) }
    public var daylight: DateInterval? { getInterval(.daylight) }

    public static func riseAndSet(date: Date = Date.now, coordinate: CLLocationCoordinate2D, timeZone: TimeZone) -> RiseSet {
        let julianDay = JulianDay(date)
        let coordinates = GeographicCoordinates(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
        let today = DateInterval(start: date.midnightLocal(timeZone: timeZone), duration: 60 * 60 * 24)

        let official = computeTwilights(julianDay: julianDay, today: today, coordinates: coordinates, degree: Degree(SolarEvent.official.value))
        
        return RiseSet(rise: official.rise, set: official.set)
    }
    
    public static func nextRiseOrSet(date: Date = Date.now, coordinate: CLLocationCoordinate2D, timeZone: TimeZone) -> (isSunrise: Bool, solar: Solar)? {
        let todayAndTomorrow = Solar.makeRange(from: date, at: coordinate, timeZone: timeZone, forDays: 2)
        var events: [(date: Date, isSunrise: Bool, solar: Solar)] = []
        
        if let todaySunrise = todayAndTomorrow[0].sunrise {
            events.append((todaySunrise, isSunrise: true, todayAndTomorrow[0]))
        }
        if let todaySunset = todayAndTomorrow[0].sunset {
            events.append((todaySunset, isSunrise: false, todayAndTomorrow[0]))
        }
        if let tomorrowSunrise = todayAndTomorrow[1].sunrise {
            events.append((tomorrowSunrise, isSunrise: true, todayAndTomorrow[1]))
        }
        if let tomorrowSunset = todayAndTomorrow[1].sunset {
            events.append((tomorrowSunset, isSunrise: false, todayAndTomorrow[1]))
        }
        
        events.sort { $0.date < $1.date }
        let next = events.first(where: { $0.date > date })

        if let next {
            return (next.isSunrise, next.solar)
        }

        return nil
    }

    public static func makeRange(from: Date, at: CLLocationCoordinate2D, timeZone: TimeZone, forDays: Int = 7) -> [Solar] {
        var solars: [Solar] = []
        
        for day in 0...(forDays - 1) {
            // TODO: Should this be done from midnight (local) instead of the current time?
            let date = from.add(days: day)
            solars.append(Solar(date: date, coordinate: at, timeZone: timeZone))
        }
        
        return solars;
    }

    public func getEvent(_ event: SolarEvent) -> Date? {
        let degrees = event.angle.converted(to: .degrees).value
        let key = Int(degrees * 1000)
        let keyValuePair = cache.first(where: { $0.key == key })
        if let keyValuePair { return event.riseSet.value(of: keyValuePair.value) }
        
        let riseSet = computeTwilights(degree: Degree(degrees))
        cache[key] = riseSet
        
        return event.riseSet.value(of: riseSet)
    }
    
    public func getInterval(_ interval: SolarInterval) -> DateInterval? {
        let start = getEvent(interval.from)
        let end = getEvent(interval.to)
        
        guard let start, let end else { return nil }
        
        return DateInterval(start: start, end: end)
    }
    
    private func computeAzimuth(date: Date?) -> Measurement<UnitAngle>? {
        guard let date else { return nil }
        
        let julianDay = JulianDay(date)
        let sun = Sun(julianDay: julianDay)
        let horizontalCoordinates = sun.makeApparentHorizontalCoordinates(with: coordinates)
        
        return Measurement<UnitAngle>(value: horizontalCoordinates.northBasedAzimuth.value, unit: .degrees)
    }

    static func computeTwilights(julianDay: JulianDay, today: DateInterval, coordinates: GeographicCoordinates, degree: Degree) -> RiseSet {
        let riseSetYesterday = Earth(julianDay: julianDay - 1).twilights(forSunAltitude: degree, coordinates: coordinates)
        let riseSetToday = Earth(julianDay: julianDay).twilights(forSunAltitude: degree, coordinates: coordinates)
        let riseSetTomorrow = Earth(julianDay: julianDay + 1).twilights(forSunAltitude: degree, coordinates: coordinates)
        
        let rise = today.inDateInterval(dates: [riseSetYesterday.riseTime?.date, riseSetToday.riseTime?.date, riseSetTomorrow.riseTime?.date])
        let set = today.inDateInterval(dates: [riseSetYesterday.setTime?.date, riseSetToday.setTime?.date, riseSetTomorrow.setTime?.date])
        
        return RiseSet(rise: rise?.toNearestMinute(), set: set?.toNearestMinute())
    }
    
    private func computeTwilights(degree: Degree) -> RiseSet {
        Self.computeTwilights(julianDay: julianDay, today: today, coordinates: coordinates, degree: degree)
    }
}
