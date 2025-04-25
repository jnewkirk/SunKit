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
        
        let riseSet = Self.riseAndSet(date: date, coordinate: coordinate, timeZone: timeZone)
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
    
    /// Makes a range of Lunar objects, starting at midnight local of the date passed
    public static func makeRange(from: Date, at: CLLocationCoordinate2D, timeZone: TimeZone, forDays: Int = 7) -> [Lunar] {
        var lunars: [Lunar] = []
        
        let midnightLocal = from.midnightLocal(timeZone: timeZone)
        
        for day in 0...(forDays - 1) {
            let date = midnightLocal.add(days: day)
            lunars.append(Lunar(date: date, coordinate: at, timeZone: timeZone))
        }
        
        return lunars;
    }
    
    public static func riseAndSet(date: Date = Date.now, coordinate: CLLocationCoordinate2D, timeZone: TimeZone) -> RiseSet {
        let julianDay = JulianDay(date)
        let coordinates = GeographicCoordinates(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
        let today = DateInterval(start: date.midnightLocal(timeZone: timeZone), duration: 60 * 60 * 24)
        
        let moonToday = Moon(julianDay: julianDay)
        
        let riseSetYesterday = Moon(julianDay: julianDay - 1).riseTransitSetTimes(for: coordinates)
        let riseSetToday = moonToday.riseTransitSetTimes(for: coordinates)
        let riseSetTomorrow = Moon(julianDay: julianDay + 1).riseTransitSetTimes(for: coordinates)
        
        let rise = today.inDateInterval(dates: [riseSetYesterday.riseTime?.date, riseSetToday.riseTime?.date, riseSetTomorrow.riseTime?.date])
        let set = today.inDateInterval(dates: [riseSetYesterday.setTime?.date, riseSetToday.setTime?.date, riseSetTomorrow.setTime?.date])
        
        return RiseSet(rise: rise?.toNearestMinute(), set: set?.toNearestMinute())
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
