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
    public init(date: Date = Date.now, coordinate: CLLocationCoordinate2D, timeZone: TimeZone) {
        self.date = date
        self.julianDay = JulianDay(date)
        self.coordinates = GeographicCoordinates(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
        self.today = DateInterval(start: date.midnightLocal(timeZone: timeZone), duration: 60 * 60 * 24)

        // Start with the sunrise and work backward
        self.sunrise = Self.getEvent(.sunrise, interval: self.today, coordinates: self.coordinates)
        self.blueHourDawnEnd = Self.getEvent(.blueHourEndDawn, interval: Self.makeInterval(self.sunrise ?? self.today.end, days: -1), coordinates: self.coordinates)
        self.civilDawn = Self.getEvent(.civilDawn, interval: Self.makeInterval(self.blueHourDawnEnd ?? self.today.end, days: -1), coordinates: self.coordinates)
        self.nauticalDawn = Self.getEvent(.nauticalDawn, interval: Self.makeInterval(self.civilDawn ?? self.today.end, days: -1), coordinates: self.coordinates)
        self.astronomicalDawn = Self.getEvent(.astronomicalDawn, interval: Self.makeInterval(self.nauticalDawn ?? self.today.end, days: -1), coordinates: self.coordinates)
        // Golden hour occurs after sunrise, so we compute it going forward rather than backward
        self.goldenHourDawnEnd = Self.getEvent(.goldenHourEndDawn, interval: Self.makeInterval(self.sunrise ?? self.today.start, days: 1), coordinates: self.coordinates)

        // Start with the sunset and work forward
        self.sunset = Self.getEvent(.sunset, interval: Self.makeInterval(self.sunrise ?? self.today.start, days: 1), coordinates: self.coordinates)
        self.blueHourDuskStart = Self.getEvent(.blueHourStartDusk, interval: Self.makeInterval(self.sunset ?? self.today.start, days: 1), coordinates: self.coordinates)
        self.civilDusk = Self.getEvent(.civilDusk, interval: Self.makeInterval(self.sunset ?? self.today.start, days: 1), coordinates: self.coordinates)
        self.nauticalDusk = Self.getEvent(.nauticalDusk, interval: Self.makeInterval(self.civilDusk ?? self.today.start, days: 1), coordinates: self.coordinates)
        self.astronomicalDusk = Self.getEvent(.astronomicalDusk, interval: Self.makeInterval(self.nauticalDusk ?? self.today.start, days: 1), coordinates: self.coordinates)
        // Golden hour occurs before sunset, so we compute it going backward rather than forward
        self.goldenHourDuskStart = Self.getEvent(.goldenHourStartDusk, interval: Self.makeInterval(self.sunset ?? self.today.end, days: -1), coordinates: self.coordinates)
    }

    let date: Date
    let julianDay: JulianDay
    let coordinates: GeographicCoordinates
    let today: DateInterval

    public let sunrise: Date?
    public let sunset: Date?
    public let civilDawn: Date?
    public let civilDusk: Date?
    public let nauticalDawn: Date?
    public let nauticalDusk: Date?
    public let astronomicalDawn: Date?
    public let astronomicalDusk: Date?
    public var blueHourDawnStart: Date? { civilDawn }
    public let blueHourDawnEnd: Date?
    public let blueHourDuskStart: Date?
    public var blueHourDuskEnd: Date? { civilDusk }
    public var goldenHourDawnStart: Date? { blueHourDawnEnd }
    public let goldenHourDawnEnd: Date?
    public let goldenHourDuskStart: Date?
    public var goldenHourDuskEnd: Date? { blueHourDuskStart }

    public var sunriseAzimuth: Measurement<UnitAngle>? { computeAzimuth(date: sunrise) }
    public var sunsetAzimuth: Measurement<UnitAngle>? { computeAzimuth(date: sunset) }
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

    /// Makes a range of events that occur within the interval at that coordinate
    internal static func makeRange(interval: DateInterval, at: GeographicCoordinates, events: Set<SolunarEventKind>, results: inout [SolunarEvent]) {
        for event in events {
            if let solarEvent = event.solarEvent { getEvents(solarEvent, interval, at, &results) }
        }
    }

    static func getEvents(_ event: SolarEvent, _ interval: DateInterval, _ coordinates: GeographicCoordinates, _ results: inout [SolunarEvent]) {
        var current = interval
        while let eventDate = getEvent(event, interval: current, coordinates: coordinates) {
            results.append(SolunarEvent(eventDate, event.kind, coordinates))
            current = DateInterval(start: eventDate.add(minutes: 1), end: current.end)
        }
    }

    /// Makes a range of Solar objects, starting at midnight local of the date passed
    public static func makeRange(from: Date, at: CLLocationCoordinate2D, timeZone: TimeZone, forDays: Int = 7) -> [Solar] {
        var solars: [Solar] = []

        let midnightLocal = from.midnightLocal(timeZone: timeZone)

        for day in 0...(forDays - 1) {
            let date = midnightLocal.add(days: day)
            solars.append(Solar(date: date, coordinate: at, timeZone: timeZone))
        }

        return solars
    }

    private static func getEvent(_ event: SolarEvent, interval: DateInterval, coordinates: GeographicCoordinates) -> Date? {
        let degrees = event.angle.converted(to: .degrees).value
        return computeRiseSet(riseSet: event.riseSet, degree: Degree(degrees), interval: interval, coordinates: coordinates)
    }

    private static func makeInterval(_ date: Date, days: Int) -> DateInterval {
        if days < 0 {
            return DateInterval(start: date.add(days: days), end: date)
        } else {
            return DateInterval(start: date, end: date.add(days: days))
        }
    }

    private func computeAzimuth(date: Date?) -> Measurement<UnitAngle>? {
        guard let date else { return nil }

        let julianDay = JulianDay(date)
        let sun = Sun(julianDay: julianDay)
        let horizontalCoordinates = sun.makeApparentHorizontalCoordinates(with: coordinates)

        return Measurement<UnitAngle>(value: horizontalCoordinates.northBasedAzimuth.value, unit: .degrees)
    }

    private static func computeRiseSet(riseSet: RiseSetEnum, julianDay: JulianDay, interval: DateInterval, coordinates: GeographicCoordinates, degree: Degree) -> Date? {
        let riseSetYesterday = Earth(julianDay: julianDay - 1).twilights(forSunAltitude: degree, coordinates: coordinates)
        let riseSetToday = Earth(julianDay: julianDay).twilights(forSunAltitude: degree, coordinates: coordinates)
        let riseSetTomorrow = Earth(julianDay: julianDay + 1).twilights(forSunAltitude: degree, coordinates: coordinates)

        if riseSet == .rise {
            return interval.inDateInterval(dates: [riseSetYesterday.riseTime?.date, riseSetToday.riseTime?.date, riseSetTomorrow.riseTime?.date])?.toNearestMinute()
        } else {
            return interval.inDateInterval(dates: [riseSetYesterday.setTime?.date, riseSetToday.setTime?.date, riseSetTomorrow.setTime?.date])?.toNearestMinute()
        }
    }

    private static func computeRiseSet(riseSet: RiseSetEnum, degree: Degree, interval: DateInterval, coordinates: GeographicCoordinates) -> Date? {
        let intervalJulianDay = JulianDay(interval.start)

        return Self.computeRiseSet(riseSet: riseSet, julianDay: intervalJulianDay, interval: interval, coordinates: coordinates, degree: degree)
    }
}
