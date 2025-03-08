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
    public static func make(date: Date = Date.now, coordinate: CLLocationCoordinate2D, timeZone: TimeZone) throws -> Solar {
        let julianDay = JulianDay(date)
        let coordinates = GeographicCoordinates(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
        let today = DateInterval(start: date.midnightLocal(timeZone: timeZone), duration: 60 * 60 * 24)

        let official = Solar.computeTwilights(julianDay: julianDay, today: today, coordinates: coordinates, zenith: Zenith.official)
        
        if let sunrise = official.rise, let sunset = official.set {
            if (sunset < sunrise) {
                throw SolarError.coordinateTimeZoneMismatch
            }
        }

        let civil = computeTwilights(julianDay: julianDay, today: today, coordinates: coordinates, zenith: Zenith.civil)
        let astronomical = computeTwilights(julianDay: julianDay, today: today, coordinates: coordinates, zenith: Zenith.astronimical)
        let nautical = computeTwilights(julianDay: julianDay, today: today, coordinates: coordinates, zenith: Zenith.nautical)
        let blueHour = computeTwilights(julianDay: julianDay, today: today, coordinates: coordinates, zenith: Zenith.blueHour)
        let goldenHour = computeTwilights(julianDay: julianDay, today: today, coordinates: coordinates, zenith: Zenith.goldenHour)
        let solarAngle = computeSolarAngle(julianDay: julianDay, coordinates: coordinates)
        let lunar = computeLunarData(julianDay: julianDay, today: today, coordinates: coordinates)
        
        return Solar(date, official, civil, astronomical, nautical, blueHour, goldenHour, solarAngle, lunar)
    }
    
    private init(_ date: Date,
                 _ official: RiseSet,
                 _ civil: RiseSet,
                 _ astronomical: RiseSet,
                 _ nautical: RiseSet,
                 _ blueHour: RiseSet,
                 _ goldenHour: RiseSet,
                 _ solarAngle: Degree,
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
        self.solarAngle = solarAngle.value
    }
    
    public let dawn: SolarEvents?
    public let dusk: SolarEvents?
    public let lunar: LunarData
    public let solarNoon: Date?
    public let daylight: DateInterval?
    public let solarAngle: Double
    
    static func computeTwilights(julianDay: JulianDay, today: DateInterval, coordinates: GeographicCoordinates, zenith: Zenith) -> RiseSet {
        let riseSetYesterday = Earth(julianDay: julianDay - 1).twilights(forSunAltitude: zenith.degree, coordinates: coordinates)
        let riseSetToday = Earth(julianDay: julianDay).twilights(forSunAltitude: zenith.degree, coordinates: coordinates)
        let riseSetTomorrow = Earth(julianDay: julianDay + 1).twilights(forSunAltitude: zenith.degree, coordinates: coordinates)
        
        let rise = Solar.inDateInterval(interval: today, dates: [riseSetYesterday.riseTime?.date, riseSetToday.riseTime?.date, riseSetTomorrow.riseTime?.date])
        let set = Solar.inDateInterval(interval: today, dates: [riseSetYesterday.setTime?.date, riseSetToday.setTime?.date, riseSetTomorrow.setTime?.date])
        
        return RiseSet(rise: rise?.withoutNanoseconds(), set: set?.withoutNanoseconds())
    }
    
    static func computeLunarData(julianDay: JulianDay, today: DateInterval, coordinates: GeographicCoordinates) -> LunarData {
        let moonToday = Moon(julianDay: julianDay)
        
        let riseSetYesterday = Moon(julianDay: julianDay - 1).riseTransitSetTimes(for: coordinates)
        let riseSetToday = moonToday.riseTransitSetTimes(for: coordinates)
        let riseSetTomorrow = Moon(julianDay: julianDay + 1).riseTransitSetTimes(for: coordinates)
        
        let rise = Solar.inDateInterval(interval: today, dates: [riseSetYesterday.riseTime?.date, riseSetToday.riseTime?.date, riseSetTomorrow.riseTime?.date])
        let set = Solar.inDateInterval(interval: today, dates: [riseSetYesterday.setTime?.date, riseSetToday.setTime?.date, riseSetTomorrow.setTime?.date])

        var illumination: Double = 0.0
        if let rise { illumination = Moon(julianDay: JulianDay(rise)).illuminatedFraction() }

        let moonAge = Solar.moonAge(julianDay: julianDay)
        let lunarPhase = Solar.lunarPhase(moonAge: moonAge)

        let equatorialCoordinates = moonToday.equatorialCoordinates
        let horizontalCoordinates = equatorialCoordinates.makeHorizontalCoordinates(for: coordinates, at: julianDay)
        
        /// TODO: These need to be sorted, and we need our lunar data to include these values so we can test them
        /// against more than one dataset
        var nextEvents: [LunarEvent] = []
        nextEvents.append(LunarEvent(phase: LunarPhase.full, date: moonToday.time(of: MoonPhase.fullMoon, mean: false).date.withoutNanoseconds()))
        nextEvents.append(LunarEvent(phase: LunarPhase.thirdQuarter, date: moonToday.time(of: MoonPhase.lastQuarter, mean: false).date.withoutNanoseconds()))
        nextEvents.append(LunarEvent(phase: LunarPhase.new, date: moonToday.time(of: MoonPhase.newMoon, mean: false).date.withoutNanoseconds()))
        nextEvents.append(LunarEvent(phase: LunarPhase.firstQuarter, date: moonToday.time(of: MoonPhase.firstQuarter, mean: false).date.withoutNanoseconds()))

        return LunarData(rise: rise?.withoutNanoseconds(),
                         set: set?.withoutNanoseconds(),
                         angle: horizontalCoordinates.altitude.value,
                         illumination: illumination,
                         phase: lunarPhase,
                         nextEvents: nextEvents)
    }
    
    static func nextFullMoon(after: JulianDay) -> Date {
        let tolerance: Double = 0.0001
        var jd = after
        
        for _ in 0..<20 {
            let moon = Moon(julianDay: jd)
            let phaseAngle = moon.phaseAngle().value

            // Stop when we're close enough to 180° (Full Moon)
            let delta = phaseAngle - 180
            print("julianDay is \(jd), delta is \(delta)")
            if abs(delta) < tolerance {
                return jd.date
            }

            // Compute derivative (rate of change of phase angle)
            let deltaJD: JulianDay = 0.001 // Small step for derivative
            let moonAhead = Moon(julianDay: jd + deltaJD)
            let derivative = (moonAhead.phaseAngle().value - phaseAngle) / deltaJD.value

            // Newton-Raphson update
            let newJD = jd - JulianDay(delta / derivative)

            // Ensure we only move forward in time
            if newJD > jd {
                jd = newJD
            } else {
                jd = jd + 0.5 // If step is negative, move forward manually
            }
        }

        return jd.date
    }

    static func computeSolarAngle(julianDay: JulianDay, coordinates: GeographicCoordinates) -> Degree {
        let sun = Sun(julianDay: julianDay)
        let equatorialCoordinates = sun.equatorialCoordinates
        let horizontalCoordinates = equatorialCoordinates.makeHorizontalCoordinates(for: coordinates, at: julianDay)
        
        return horizontalCoordinates.altitude
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
    
    static func moonAge(julianDay: JulianDay) -> Double {
        // Known new moon date (January 6, 2000 at 18:14 UTC)
        let knownNewMoonJD = 2451550.26
        
        var age = fmod(julianDay.value - knownNewMoonJD, Constant.synodicMonth)
        if (age < 0) {
            age = age + Constant.synodicMonth
        }
        return age
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
