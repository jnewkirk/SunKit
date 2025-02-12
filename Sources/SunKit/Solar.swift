//
//  Solar.swift
//  SunKit
//
//  Copyright © 2025 James Newkirk, Brad Wilson. All rights reserved.
//

import Foundation
import CoreLocation

public struct Solar: Codable, Sendable {
    public init(date: Date,
                coordinate: CLLocationCoordinate2D) {
        self.date = date
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        
        let dayOfTheYear = Double(Constant.calendar.ordinality(of: .day, in: .year, for: date)!)
        let longitudinalHour = coordinate.longitude / 15
        
        let risingSunPosition = Solar.calculcateSunPosition(isSunrise: true, dayOfTheYear, longitudinalHour)
        let sunrise = Solar.calculateSolarEvent(date, coordinate, Zenith.official, risingSunPosition)
        if (sunrise != nil) {
            let sunrise = sunrise!
            let civil = Solar.calculateSolarEvent(date, coordinate, Zenith.civil, risingSunPosition)
            let astronomical = Solar.calculateSolarEvent(date, coordinate, Zenith.astronimical, risingSunPosition)
            let nautical = Solar.calculateSolarEvent(date, coordinate, Zenith.nautical, risingSunPosition)
            let blueHour = Solar.calculateSolarEvent(date, coordinate, Zenith.blueHour, risingSunPosition)
            let goldenHourEnd = Solar.calculateSolarEvent(date, coordinate, Zenith.goldenHour, risingSunPosition)
            
            let goldenHourInterval = DateInterval(start: blueHour, end: goldenHourEnd)
            let blueHourInterval = DateInterval(start: civil, end: blueHour)
            let dawnInterval = DateInterval(start: astronomical, end: goldenHourEnd)
            
            self.dawn = SolarEvents(sunrise,
                                    nautical: nautical,
                                    astronomical: astronomical,
                                    civil: civil,
                                    goldenHour: goldenHourInterval,
                                    blueHour: blueHourInterval,
                                    interval: dawnInterval)
        } else {
            self.dawn = nil
        }
        
        let settingSunPosition = Solar.calculcateSunPosition(isSunrise: false, dayOfTheYear, longitudinalHour)
        let sunset = Solar.calculateSolarEvent(date, coordinate, Zenith.official, settingSunPosition)
        if (sunset != nil) {
            let sunset = sunset!
            let civil = Solar.calculateSolarEvent(date, coordinate, Zenith.civil, settingSunPosition)
            let astronomical = Solar.calculateSolarEvent(date, coordinate, Zenith.astronimical, settingSunPosition)
            let nautical = Solar.calculateSolarEvent(date, coordinate, Zenith.nautical, settingSunPosition)
            let blueHour = Solar.calculateSolarEvent(date, coordinate, Zenith.blueHour, settingSunPosition)
            let goldenHourStart = Solar.calculateSolarEvent(date, coordinate, Zenith.goldenHour, settingSunPosition)
            
            self.dusk = SolarEvents(sunset,
                                    nautical: nautical,
                                    astronomical: astronomical,
                                    civil: civil,
                                    goldenHour: DateInterval(start: goldenHourStart, end: blueHour),
                                    blueHour: DateInterval(start: blueHour, end: civil),
                                    interval: DateInterval(start: goldenHourStart, end: astronomical))
        } else {
            self.dusk = nil
        }
        
        if (sunrise != nil && sunset != nil) {
            self.daylight = DateInterval(start: sunrise!, end: sunset!)
            self.solarNoon = sunrise! + ((sunset!.timeIntervalSince1970 - sunrise!.timeIntervalSince1970) / 2)
        } else {
            self.daylight = nil
            self.solarNoon = nil
        }
        
        let julianDate = Solar.julianDay(from: date)
        let moonAge = Solar.moonAge(julianDate: julianDate)
        let lunarPhase = Solar.lunarPhase(moonAge: moonAge)
        let lunarIllumination = Solar.lunarIllumination(moonAge: moonAge)
 
        self.lunar = LunarData(illumination: lunarIllumination, phase: lunarPhase)
    }
    
    let date: Date
    let latitude: Double
    let longitude: Double
    public let dawn: SolarEvents?
    public let dusk: SolarEvents?
    public let lunar: LunarData
    public let solarNoon: Date?
    public let daylight: DateInterval?
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    public static func makeRange(from: Date, at: CLLocationCoordinate2D, forDays: Int = 7) -> [Solar] {
        var solars: [Solar] = []
        
        for day in 0...(forDays - 1) {
            let date = from.addingTimeInterval(60 * 60 * 24 * Double(day))
            solars.append(Solar(date: date, coordinate: at))
        }
        
        return solars;
    }
    
    /// TODO: Sunlight angle
    /// TODO: Moon phase
    /// TODO: Moon illumination
    /// TODO: Moon rise/moon set
    
    fileprivate struct SunPosition {
        let isSunrise: Bool
        let time: Double
        let sunDeclinationSineRadians: Double
        let rightAscensionHours: Double
        let longitudinalHour: Double
    }
    
    fileprivate static func calculcateSunPosition(isSunrise: Bool,
                                                  _ dayOfTheYear: Double,
                                                  _ longitudinalHour: Double) -> SunPosition {
        let time: Double
        if (isSunrise) {
            time = dayOfTheYear + ((6 - longitudinalHour) / 24)
        } else {
            time = dayOfTheYear + ((18 - longitudinalHour) / 24)
        }
        
        let meanAnomolyDegrees = (0.9856 * time) - 3.289
        
        let trueLongitudeDegrees = normalizeDegrees(
            meanAnomolyDegrees +
            (1.916 * sin(meanAnomolyDegrees.degreesToRadians)) +
            (0.020 * sin(2 * meanAnomolyDegrees.degreesToRadians)) +
            282.634
        )
        
        var sunRightAscensionDegrees = normalizeDegrees(
            atan(0.91764 * tan(trueLongitudeDegrees.degreesToRadians)).radiansToDegrees
        )
        
        // Ensure right ascension and longitude are in the same quadrant
        let longitudeQuadrant = floor(trueLongitudeDegrees / 90) * 90
        let rightAscensionQuadrant = floor(sunRightAscensionDegrees / 90) * 90
        sunRightAscensionDegrees += (longitudeQuadrant - rightAscensionQuadrant)
        
        let rightAscensionHours = sunRightAscensionDegrees / 15
        let sunDeclinationSineRadians = 0.39782 * sin(trueLongitudeDegrees.degreesToRadians)
        
        return SunPosition(isSunrise: isSunrise, time: time, sunDeclinationSineRadians: sunDeclinationSineRadians, rightAscensionHours: rightAscensionHours, longitudinalHour: longitudinalHour)
    }
    
    fileprivate static func calculateSolarEvent(_ date: Date,
                                                _ coordinate: CLLocationCoordinate2D,
                                                _ zenith: Zenith,
                                                _ sunPosition: SunPosition) -> Date? {
        let localHourAngleCosine = calculateLocalHourAngleCosine(coordinate, zenith.rawValue, sunPosition.sunDeclinationSineRadians, sunPosition.rightAscensionHours)
        if (localHourAngleCosine > 1 || localHourAngleCosine < -1) {
            return nil
        }
        
        let hourUTC = calculateHourUTC(sunPosition.isSunrise, coordinate, sunPosition.time, localHourAngleCosine, sunPosition.rightAscensionHours, sunPosition.longitudinalHour)
        return calculateDate(sunPosition.isSunrise, date, hourUTC, sunPosition.longitudinalHour)
    }
    
    fileprivate static func calculateHourUTC(_ isSunrise: Bool,
                                             _ coordinate: CLLocationCoordinate2D,
                                             _ time: Double,
                                             _ localHourAngleCosine: Double,
                                             _ rightAscensionHours: Double,
                                             _ longitudinalHour: Double) -> Double {
        let hour: Double
        if (isSunrise) {
            hour = (360 - acos(localHourAngleCosine).radiansToDegrees)
        } else {
            hour = acos(localHourAngleCosine).radiansToDegrees
        }
        
        let localMeanTime = (hour / 15) + rightAscensionHours - (0.06571 * time) - 6.622
        
        return normalizeHour(localMeanTime - longitudinalHour)
    }
    
    fileprivate static func calculateDate(_ isSunrise: Bool,
                                          _ from: Date,
                                          _ offsetBy: Double,
                                          _ longitudinalHour: Double) -> Date? {
        // Calculate all of the sunrise's / sunset's date components
        let hourComponent = floor(offsetBy)
        let minuteComponent = floor((offsetBy - hourComponent) * 60.0)
        let secondComponent = (((offsetBy - hourComponent) * 60) - minuteComponent) * 60.0
        
        let shouldBeYesterday = isSunrise && longitudinalHour > 0 && offsetBy > 12
        let shouldBeTomorrow = !isSunrise && longitudinalHour < 0 && offsetBy < 12
        
        let setDate: Date
        if shouldBeYesterday {
            setDate = Date(timeInterval: -(60 * 60 * 24), since: from)
        } else if shouldBeTomorrow {
            setDate = Date(timeInterval: (60 * 60 * 24), since: from)
        } else {
            setDate = from
        }
        
        var components = Constant.calendar.dateComponents([.day, .month, .year], from: setDate)
        components.hour = Int(hourComponent)
        components.minute = Int(minuteComponent)
        components.second = Int(secondComponent)
        
        return Constant.calendar.date(from: components)
    }
    
    fileprivate static func calculateLocalHourAngleCosine(_ coordinate: CLLocationCoordinate2D,
                                                          _ zenith: Double,
                                                          _ sunDeclinationSineRadians: Double,
                                                          _ rightAscensionHours: Double) -> Double {
        let sunDeclinationCosineRadians = cos(asin(sunDeclinationSineRadians))
        
        return (cos(zenith.degreesToRadians) - (sunDeclinationSineRadians * sin(coordinate.latitude.degreesToRadians))) / (sunDeclinationCosineRadians * cos(coordinate.latitude.degreesToRadians))
    }
    
    fileprivate static func normalizeDegrees(_ value: Double) -> Double {
        return normalize(value, max: 360)
    }
    
    fileprivate static func normalizeHour(_ value: Double) -> Double {
        return normalize(value, max: 24)
    }
    
    fileprivate static func normalize(_ value: Double, max: Double) -> Double {
        var value = value
        
        if value < 0 {
            value += max
        }
        
        if value > max {
            value -= max
        }
        
        return value
    }
    
    fileprivate enum Zenith: Double, CaseIterable {
        case goldenHour = 84
        case official = 90.83
        case blueHour = 94
        case civil = 96
        case nautical = 102
        case astronimical = 108
    }
}

extension Solar {
    /// Convert Date to Julian Day (JD)
    static func julianDay(from date: Date) -> Double {
        let components = Constant.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .era], from: date)
        
        guard var year = components.year,
              let month = components.month,
              let day = components.day,
              let hour = components.hour,
              let minute = components.minute,
              let second = components.second else {
            return 0.0
        }
        
        if (components.era == 0) {
            year = -year + 1;
        }
        
        var Y = year
        var M = month
        
        // If month is January or February, treat it as the 13th or 14th month of the previous year
        if M <= 2 {
            Y -= 1
            M += 12
        }
        
        let A = Y / 100
        let B = 2 - A + (A / 4)
        
        let JD =
        floor(365.25 * Double(Y + 4716)) +
        floor(30.6001 * Double(M + 1)) +
        Double(day) +
        Double(B) - 1524
        
        // Convert time to fractional day
        let dayFraction = (Double(hour) - 12.0) / 24.0 + Double(minute) / 1440.0 + Double(second) / 86400.0
        
        return JD + dayFraction
    }
    
    static func moonAge(julianDate: Double) -> Double {
        // Known new moon date (January 6, 2000 at 18:14 UTC)
        let knownNewMoonJD = 2451549.5
        
        var age = fmod(julianDate - knownNewMoonJD, Constant.synodicMonth)
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
    
    static func lunarIllumination(moonAge: Double) -> Double {
        let phaseAngle = (moonAge / Constant.synodicMonth) * 360.0
        let illumination = 50.0 * (1 - cos(phaseAngle.degreesToRadians))
        
        return round(illumination * 100.0) / 100.0
    }
    
    static func calculateMoonriseMoonset(latitude: Double, longitude: Double, moonAge: Double, date: Date, julianDate: Double) -> (moonRise: Date?, moonSet: Date?) {
        let moonPhaseAngle = (moonAge / Constant.synodicMonth) * 360.0
        
        // Approximate Moon's Declination
        let moonDeclination = 23.44 * sin(moonPhaseAngle.degreesToRadians)
        let localSiderealTime = getLocalSiderealTime(longitude: longitude, julianDate: julianDate)
        
        let cosH =
            (sin(-0.833.degreesToRadians) - sin(latitude.degreesToRadians) * sin(moonDeclination.degreesToRadians)) /
            (cos(latitude.degreesToRadians) * cos(moonDeclination.degreesToRadians))

        // Hour Angle Calculation
        let hourAngle = acos(cosH).radiansToDegrees
        
        // Apply Refraction Correction (~0.566° near horizon)
        let refractionCorrection = 0.566
        let correctedHourAngle = hourAngle - refractionCorrection
        
        // Compute Moonrise & Moonset Times
        let moonriseTime = (localSiderealTime - correctedHourAngle) / 15.0  // Convert hour angle to time
        let moonsetTime = (localSiderealTime + correctedHourAngle) / 15.0
        
        let today = Constant.calendar.startOfDay(for: date)
        
        let riseDate = Constant.calendar.date(byAdding: .hour, value: Int(moonriseTime), to: today)
        let setDate = Constant.calendar.date(byAdding: .hour, value: Int(moonsetTime), to: today)
        
        return (moonRise: riseDate, moonSet: setDate)
    }
    
    static func getLocalSiderealTime(longitude: Double, julianDate: Double) -> Double {
        let s = julianDate - 2451545.0
        let t = s / 36525.0
        let lst = 280.46061837 + 360.98564736629 * s + 0.000387933 * t * t - (t * t * t) / 38710000.0
        
        return (lst + longitude).truncatingRemainder(dividingBy: 360.0)
    }
}

private extension DateInterval {
    init?(start: Date?, end: Date?) {
        guard let start, let end else { return nil }
        
        self.init(start: start, end: end)
    }
}

private extension Double {
    var degreesToRadians: Double {
        return Double(self) * (Double.pi / 180.0)
    }
    
    var radiansToDegrees: Double {
        return (Double(self) * 180.0) / Double.pi
    }
}
