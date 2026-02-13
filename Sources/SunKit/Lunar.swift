//
//  Lunar.swift
//  SunKit
//
//  Created by Jim Newkirk on 3/14/25.
//

import Foundation
import CoreLocation
import SwiftAA

public struct Lunar {
    public init(date: Date = Date.now, coordinate: CLLocationCoordinate2D, timeZone: TimeZone) {
        let julianDay = JulianDay(date)
        let coordinates = GeographicCoordinates(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
        moonToday = Moon(julianDay: julianDay)

        let riseSet = Self.moonRiseAndSet(date: date, coordinate: coordinate, timeZone: timeZone)
        rise = riseSet.rise
        set = riseSet.set

        if let rise { illumination = Moon(julianDay: JulianDay(rise)).illuminatedFraction() } else { illumination = 0.0 }

        let moonAge = Self.moonAge(julianDay: julianDay)
        phase = Self.lunarPhase(moonAge: moonAge)

        let equatorialCoordinates = moonToday.equatorialCoordinates
        let horizontalCoordinates = equatorialCoordinates.makeHorizontalCoordinates(for: coordinates, at: julianDay)

        angle = horizontalCoordinates.altitude.value
    }

    let moonToday: Moon
    public let rise: Date?
    public let set: Date?
    public let angle: Double
    public let illumination: Double
    public let phase: LunarPhase
    public var nextEvents: [LunarEvent] {
        var nextEvents: [LunarEvent] = []

        nextEvents.append(LunarEvent(phase: LunarPhase.new, date: moonToday.time(of: MoonPhase.newMoon, mean: false).date.toNearestMinute()))
        nextEvents.append(LunarEvent(phase: LunarPhase.full, date: moonToday.time(of: MoonPhase.fullMoon, mean: false).date.toNearestMinute()))
        nextEvents.append(LunarEvent(phase: LunarPhase.firstQuarter, date: moonToday.time(of: MoonPhase.firstQuarter, mean: false).date.toNearestMinute()))
        nextEvents.append(LunarEvent(phase: LunarPhase.thirdQuarter, date: moonToday.time(of: MoonPhase.lastQuarter, mean: false).date.toNearestMinute()))
        nextEvents.sort { $0.date < $1.date }

        return nextEvents
    }

    /// Makes a range of events that occur within the interval at that coordinate
    internal static func makeRange(interval: DateInterval, at: GeographicCoordinates, events: Set<SolunarEventKind>, results: inout [SolunarEvent]) {
        for event in events {
            getEvents(event, interval, at, &results)
        }
    }

    static func getEvents(_ eventKind: SolunarEventKind, _ interval: DateInterval, _ coordinates: GeographicCoordinates, _ results: inout [SolunarEvent]) {
        var current = interval
        while let eventDate = getEvent(eventKind, interval: current, coordinates: coordinates) {
            results.append(SolunarEvent(eventDate, eventKind, coordinates))
            current = DateInterval(start: eventDate.add(minutes: 1), end: current.end)
        }
    }

    /// Makes a range of Lunar objects, starting at midnight local of the date passed
    public static func makeRange(from: Date, at: CLLocationCoordinate2D, timeZone: TimeZone, forDays: Int = 7) -> [Lunar] {
        var lunars: [Lunar] = []

        let midnightLocal = from.midnightLocal(timeZone: timeZone)

        for day in 0...(forDays - 1) {
            let date = midnightLocal.add(days: day)
            lunars.append(Lunar(date: date, coordinate: at, timeZone: timeZone))
        }

        return lunars
    }
    
    private static func getEvent(_ eventKind: SolunarEventKind, interval: DateInterval, coordinates: GeographicCoordinates) -> Date? {
        guard let riseSet = eventKind.riseSet else { return nil }
        var riseAndSet: RiseSet
        
        if (eventKind == .galacticCenterVisibilityStart || eventKind == .galacticCenterVisibilityEnd) {
            riseAndSet = galacticCenterRiseSet(interval: interval, coordinates: coordinates)
        } else {
            riseAndSet = moonRiseAndSet(interval: interval, coordinates: coordinates)
        }

        return riseSet == RiseSetEnum.rise ? riseAndSet.rise : riseAndSet.set;
    }

    private static func moonRiseAndSet(date: Date = Date.now, coordinate: CLLocationCoordinate2D, timeZone: TimeZone) -> RiseSet {
        let today = DateInterval(start: date.midnightLocal(timeZone: timeZone), duration: 60 * 60 * 24)
        let coordinates = GeographicCoordinates(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))

        return moonRiseAndSet(interval: today, coordinates: coordinates)
    }

    // Galactic Center rise/set calculation using SwiftAA
    static func galacticCenterRiseSet(interval: DateInterval, coordinates: GeographicCoordinates) -> RiseSet {
        let julianDay = JulianDay(interval.start).midnight
        
        // Sagittarius A* (Galactic Center) fixed coordinates (J2000)
        // RA: 17h 45m 40s, Dec: -29° 00' 28"
        let rightAscension = Hour(17 + 45.0/60.0 + 40.0/3600.0)  // 17.761111 hours
        let declination = Degree(-29 - 0/60.0 - 28.0/3600.0)      // -29.007778 degrees
        
        // Create fixed equatorial coordinates for Sagittarius A*
        let galacticCenter = EquatorialCoordinates(alpha: rightAscension, delta: declination)
        
        // Standard altitude for stars and planets
        let apparentRiseSetAltitude = Degree(-0.5667)  // -34 arcminutes
        
        // Calculate for yesterday, today, and tomorrow
        // Since Sagittarius A* is a fixed star, coordinates don't change
        let riseSetYesterday = riseTransitSet(
            forJulianDay: julianDay - 1,
            equCoords1: galacticCenter,
            equCoords2: galacticCenter,
            equCoords3: galacticCenter,
            geoCoords: coordinates,
            apparentRiseSetAltitude: apparentRiseSetAltitude
        )
        
        let riseSetToday = riseTransitSet(
            forJulianDay: julianDay,
            equCoords1: galacticCenter,
            equCoords2: galacticCenter,
            equCoords3: galacticCenter,
            geoCoords: coordinates,
            apparentRiseSetAltitude: apparentRiseSetAltitude
        )
        
        let riseSetTomorrow = riseTransitSet(
            forJulianDay: julianDay + 1,
            equCoords1: galacticCenter,
            equCoords2: galacticCenter,
            equCoords3: galacticCenter,
            geoCoords: coordinates,
            apparentRiseSetAltitude: apparentRiseSetAltitude
        )
        
        // Find which date falls within the interval
        let rise = interval.inDateInterval(dates: [
            riseSetYesterday.isRiseValid ? riseSetYesterday.riseTime.date : nil,
            riseSetToday.isRiseValid ? riseSetToday.riseTime.date : nil,
            riseSetTomorrow.isRiseValid ? riseSetTomorrow.riseTime.date : nil
        ])
        
        let set = interval.inDateInterval(dates: [
            riseSetYesterday.isSetValid ? riseSetYesterday.setTime.date : nil,
            riseSetToday.isSetValid ? riseSetToday.setTime.date : nil,
            riseSetTomorrow.isSetValid ? riseSetTomorrow.setTime.date : nil
        ])
        
        return RiseSet(rise: rise?.toNearestMinute(), set: set?.toNearestMinute())
    }
    
    private static func moonRiseAndSet(interval: DateInterval, coordinates: GeographicCoordinates) -> RiseSet {
        let julianDay = JulianDay(interval.start)

        let moonToday = Moon(julianDay: julianDay)

        let riseSetYesterday = Moon(julianDay: julianDay - 1).riseTransitSetTimes(for: coordinates)
        let riseSetToday = moonToday.riseTransitSetTimes(for: coordinates)
        let riseSetTomorrow = Moon(julianDay: julianDay + 1).riseTransitSetTimes(for: coordinates)

        let rise = interval.inDateInterval(dates: [riseSetYesterday.riseTime?.date, riseSetToday.riseTime?.date, riseSetTomorrow.riseTime?.date])
        let set = interval.inDateInterval(dates: [riseSetYesterday.setTime?.date, riseSetToday.setTime?.date, riseSetTomorrow.setTime?.date])

        return RiseSet(rise: rise?.toNearestMinute(), set: set?.toNearestMinute())
    }

    static func moonAge(julianDay: JulianDay) -> Double {
        // Known new moon date (January 6, 2000 at 18:14 UTC)
        let knownNewMoonJD = 2451550.26

        var age = fmod(julianDay.value - knownNewMoonJD, Constant.synodicMonth)
        if age < 0 {
            age += Constant.synodicMonth
        }
        return age
    }

    static func lunarPhase(moonAge: Double) -> LunarPhase {
        if moonAge < Constant.lunarFirstQuarter {
            return .waxingCrescent
        }
        if moonAge < Constant.lunarFull {
            return .waxingGibbous
        }
        if moonAge < Constant.lunarThirdQuarter {
            return .waningGibbous
        }

        return .waningCrescent
    }
}
