//
//  Solar.swift
//  SunKit
//
//  Copyright © 2025 James Newkirk, Brad Wilson. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftAA

public enum SolarError : Error {
    case coordinateTimeZoneMismatch
}

public struct Solar: Sendable {
    public static func make(date: Date, coordinate: CLLocationCoordinate2D, timeZone: TimeZone) throws -> Solar {
        let official = Solar.computeTwilights(date: date, timeZone: timeZone, coordinate: coordinate, zenith: Zenith.official)
        
        if let sunrise = official.rise, let sunset = official.set {
            if (sunset < sunrise) {
                throw SolarError.coordinateTimeZoneMismatch
            }
        }
        
        let civil = Solar.computeTwilights(date: date, timeZone: timeZone, coordinate: coordinate, zenith: Zenith.civil)
        let astronomical = Solar.computeTwilights(date: date, timeZone: timeZone, coordinate: coordinate, zenith: Zenith.astronimical)
        let nautical = Solar.computeTwilights(date: date, timeZone: timeZone, coordinate: coordinate, zenith: Zenith.nautical)
        let blueHour = Solar.computeTwilights(date: date, timeZone: timeZone, coordinate: coordinate, zenith: Zenith.blueHour)
        let goldenHour = Solar.computeTwilights(date: date, timeZone: timeZone, coordinate: coordinate, zenith: Zenith.goldenHour)
        let lunar = computeLunarData(date: date, timeZone: timeZone, coordinate: coordinate)
        
        return Solar(date, official, civil, astronomical, nautical, blueHour, goldenHour, lunar)
    }
    
    private init(_ date: Date,
                 _ official: RiseSet,
                 _ civil: RiseSet,
                 _ astronomical: RiseSet,
                 _ nautical: RiseSet,
                 _ blueHour: RiseSet,
                 _ goldenHour: RiseSet,
                 _ lunar: LunarData) {
        let sunrise = official.rise
        if let sunrise {
            self.dawn = SolarEvents(sunrise,
                                    nautical: nautical.rise,
                                    astronomical: astronomical.rise,
                                    civil: civil.rise,
                                    goldenHour: DateInterval(start: blueHour.rise, end: goldenHour.rise),
                                    blueHour: DateInterval(start: civil.rise, end: blueHour.rise),
                                    interval: DateInterval(start: astronomical.rise, end: goldenHour.rise))
        } else {
            self.dawn = nil
        }
        
        let sunset = official.set
        if let sunset {
            self.dusk = SolarEvents(sunset,
                                    nautical: nautical.set,
                                    astronomical: astronomical.set,
                                    civil: civil.set,
                                    goldenHour: DateInterval(start: goldenHour.set, end: blueHour.set),
                                    blueHour: DateInterval(start: blueHour.set, end: civil.set),
                                    interval: DateInterval(start: goldenHour.set, end: astronomical.set))
        } else {
            self.dusk = nil
        }
        
        if let sunrise, let sunset {
            self.daylight = DateInterval(start: sunrise, end: sunset)
            self.solarNoon = sunrise + ((sunset.timeIntervalSince1970 - sunrise.timeIntervalSince1970) / 2)
        } else {
            self.daylight = nil
            self.solarNoon = nil
        }
        
        self.lunar = lunar
    }
    
    public let dawn: SolarEvents?
    public let dusk: SolarEvents?
    public let lunar: LunarData
    public let solarNoon: Date?
    public let daylight: DateInterval?
    
    static func computeTwilights(date: Date, timeZone: TimeZone, coordinate: CLLocationCoordinate2D, zenith: Zenith) -> RiseSet {
        let jd = JulianDay(date)
        let coordinates = GeographicCoordinates(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
        let today = DateInterval(start: date.midnightLocal(timeZone: timeZone), duration: 60 * 60 * 24)
        
        let riseSetYesterday = Earth(julianDay: jd - 1).twilights(forSunAltitude: zenith.degree, coordinates: coordinates)
        let riseSetToday = Earth(julianDay: jd).twilights(forSunAltitude: zenith.degree, coordinates: coordinates)
        let riseSetTomorrow = Earth(julianDay: jd + 1).twilights(forSunAltitude: zenith.degree, coordinates: coordinates)
        
        let rise = Solar.inDateInterval(interval: today, dates: [riseSetYesterday.riseTime?.date, riseSetToday.riseTime?.date, riseSetTomorrow.riseTime?.date])
        let set = Solar.inDateInterval(interval: today, dates: [riseSetYesterday.setTime?.date, riseSetToday.setTime?.date, riseSetTomorrow.setTime?.date])
        
        return RiseSet(rise: rise?.withoutNanoseconds(), set: set?.withoutNanoseconds())
    }
    
    static func computeLunarData(date: Date, timeZone: TimeZone, coordinate: CLLocationCoordinate2D) -> LunarData {
        let jd = JulianDay(date)
        let coordinates = GeographicCoordinates(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
        let today = DateInterval(start: date.midnightLocal(timeZone: timeZone), duration: 60 * 60 * 24)
        
        let riseSetYesterday = Moon(julianDay: jd - 1).riseTransitSetTimes(for: coordinates)
        let riseSetToday = Moon(julianDay: jd).riseTransitSetTimes(for: coordinates)
        let riseSetTomorrow = Moon(julianDay: jd + 1).riseTransitSetTimes(for: coordinates)
        
        let rise = Solar.inDateInterval(interval: today, dates: [riseSetYesterday.riseTime?.date, riseSetToday.riseTime?.date, riseSetTomorrow.riseTime?.date])
        let set = Solar.inDateInterval(interval: today, dates: [riseSetYesterday.setTime?.date, riseSetToday.setTime?.date, riseSetTomorrow.setTime?.date])

        var illumination: Double = 0.0
        if let rise { illumination = Moon(julianDay: JulianDay(rise)).illuminatedFraction() }

        let moonAge = Solar.moonAge(julianDay: jd)
        let lunarPhase = Solar.lunarPhase(moonAge: moonAge)

        return LunarData(rise: rise?.withoutNanoseconds(), set: set?.withoutNanoseconds(), illumination: illumination, phase: lunarPhase)
    }
    
    static func inDateInterval(interval: DateInterval, dates: [Date?]) -> Date? {
        for date in dates {
            if let date, interval.contains(date) {
                return Date(timeIntervalSince1970: Double(Int(date.timeIntervalSince1970)))
            }
        }
        
        return nil
    }
    
    public static func makeRange(from: Date, at: CLLocationCoordinate2D, timeZone: TimeZone, forDays: Int = 7) throws -> [Solar] {
        var solars: [Solar] = []
        
        for day in 0...(forDays - 1) {
            let date = from.addingTimeInterval(60 * 60 * 24 * Double(day))
            solars.append(try Solar.make(date: date, coordinate: at, timeZone: timeZone))
        }
        
        return solars;
    }
    
    /// TODO: Sunlight angle
    /// TODO: Moon rise/moon set
}

struct RiseSet {
    let rise: Date?
    let set: Date?
}

extension Solar {
    static func moonAge(julianDay: JulianDay) -> Double {
        // Known new moon date (January 6, 2000 at 18:14 UTC)
        let knownNewMoonJD = 2451549.5
        
        var age = fmod(julianDay.value - knownNewMoonJD, Constant.synodicMonth)
        if (age < 0) {
            age = age + Constant.synodicMonth
        }
        return round(age * 10.0) / 10.0
    }
    
    static func lunarPhase(moonAge: Double) -> LunarPhase {
        if (moonAge < Constant.lunarFirstQuarter) {
            return .waxingCrescent
        }
        if (moonAge < Constant.lunarFull) {
            return .waxingGibbous
        }
        if (moonAge < Constant.lunarThirdQuarter) {
            return .waningGibbous
        }
        
        return .waningCrescent
    }
}

private extension DateInterval {
    init?(start: Date?, end: Date?) {
        guard let start, let end else { return nil }
        
        self.init(start: start, end: end)
    }
}
