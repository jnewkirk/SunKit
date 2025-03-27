//
//  Solar.swift
//  SunKit
//
//  Copyright © 2025 James Newkirk, Brad Wilson. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftAA

public struct Solar {
    public static func make(date: Date = Date.now, coordinate: CLLocationCoordinate2D, timeZone: TimeZone) -> Solar {
        let julianDay = JulianDay(date)
        let coordinates = GeographicCoordinates(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
        let today = DateInterval(start: date.midnightLocal(timeZone: timeZone), duration: 60 * 60 * 24)

        let official = computeTwilights(julianDay: julianDay, today: today, coordinates: coordinates, zenith: Zenith.official)
        let civil = computeTwilights(julianDay: julianDay, today: today, coordinates: coordinates, zenith: Zenith.civil)
        let astronomical = computeTwilights(julianDay: julianDay, today: today, coordinates: coordinates, zenith: Zenith.astronimical)
        let nautical = computeTwilights(julianDay: julianDay, today: today, coordinates: coordinates, zenith: Zenith.nautical)
        let blueHour = computeTwilights(julianDay: julianDay, today: today, coordinates: coordinates, zenith: Zenith.blueHour)
        let goldenHour = computeTwilights(julianDay: julianDay, today: today, coordinates: coordinates, zenith: Zenith.goldenHour)
        let solarAngle = computeSolarAngle(julianDay: julianDay, coordinates: coordinates)
        
        return Solar(date, official, civil, astronomical, nautical, blueHour, goldenHour, solarAngle)
    }
    
    public static func riseAndSet(date: Date = Date.now, coordinate: CLLocationCoordinate2D, timeZone: TimeZone) -> RiseSet {
        let julianDay = JulianDay(date)
        let coordinates = GeographicCoordinates(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
        let today = DateInterval(start: date.midnightLocal(timeZone: timeZone), duration: 60 * 60 * 24)

        let official = computeTwilights(julianDay: julianDay, today: today, coordinates: coordinates, zenith: Zenith.official)
        
        return RiseSet(rise: official.rise, set: official.set)
    }
    
    private init(_ date: Date,
                 _ official: RiseSet,
                 _ civil: RiseSet,
                 _ astronomical: RiseSet,
                 _ nautical: RiseSet,
                 _ blueHour: RiseSet,
                 _ goldenHour: RiseSet,
                 _ angle: Degree) {
        let sunrise = official.rise
        self.dawn = SolarEvents(sunrise,
                                nautical: nautical.rise,
                                astronomical: astronomical.rise,
                                civil: civil.rise,
                                goldenHour: DateInterval(start: blueHour.rise, end: goldenHour.rise),
                                blueHour: DateInterval(start: civil.rise, end: blueHour.rise),
                                interval: DateInterval(start: astronomical.rise, end: goldenHour.rise))

        let sunset = official.set
        self.dusk = SolarEvents(sunset,
                                nautical: nautical.set,
                                astronomical: astronomical.set,
                                civil: civil.set,
                                goldenHour: DateInterval(start: goldenHour.set, end: blueHour.set),
                                blueHour: DateInterval(start: blueHour.set, end: civil.set),
                                interval: DateInterval(start: goldenHour.set, end: astronomical.set))
        
        self.daylight = DateInterval(start: sunrise, end: sunset)
        
        if let sunrise, let sunset {
            self.solarNoon = Date(timeIntervalSince1970: (sunrise.timeIntervalSince1970 + ((sunset.timeIntervalSince1970 - sunrise.timeIntervalSince1970) / 2))).toNearestMinute()
        } else {
            self.solarNoon = nil
        }
        
        self.angle = angle.value
    }
    
    public let dawn: SolarEvents
    public let dusk: SolarEvents
    public let solarNoon: Date?
    public let daylight: DateInterval?
    public let angle: Double
    
    static func computeTwilights(julianDay: JulianDay, today: DateInterval, coordinates: GeographicCoordinates, zenith: Zenith) -> RiseSet {
        let riseSetYesterday = Earth(julianDay: julianDay - 1).twilights(forSunAltitude: zenith.degree, coordinates: coordinates)
        let riseSetToday = Earth(julianDay: julianDay).twilights(forSunAltitude: zenith.degree, coordinates: coordinates)
        let riseSetTomorrow = Earth(julianDay: julianDay + 1).twilights(forSunAltitude: zenith.degree, coordinates: coordinates)
        
        let rise = today.inDateInterval(dates: [riseSetYesterday.riseTime?.date, riseSetToday.riseTime?.date, riseSetTomorrow.riseTime?.date])
        let set = today.inDateInterval(dates: [riseSetYesterday.setTime?.date, riseSetToday.setTime?.date, riseSetTomorrow.setTime?.date])
        
        return RiseSet(rise: rise?.toNearestMinute(), set: set?.toNearestMinute())
    }
    
    static func computeSolarAngle(julianDay: JulianDay, coordinates: GeographicCoordinates) -> Degree {
        let sun = Sun(julianDay: julianDay)
        let equatorialCoordinates = sun.equatorialCoordinates
        let horizontalCoordinates = equatorialCoordinates.makeHorizontalCoordinates(for: coordinates, at: julianDay)
        
        return horizontalCoordinates.altitude
    }
    
    public static func makeRange(from: Date, at: CLLocationCoordinate2D, timeZone: TimeZone, forDays: Int = 7) -> [Solar] {
        var solars: [Solar] = []
        
        for day in 0...(forDays - 1) {
            let date = from.addingTimeInterval(60 * 60 * 24 * Double(day))
            solars.append(Solar.make(date: date, coordinate: at, timeZone: timeZone))
        }
        
        return solars;
    }
}
