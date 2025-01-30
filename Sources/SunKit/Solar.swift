//
//  Solar.swift
//  SunKit
//
//  Created by Jim Newkirk on 1/29/25.
//

import Foundation
import CoreLocation

public struct Solar: Sendable {
    public init(date: Date,
                coordinate: CLLocationCoordinate2D) {
        self.date = date
        self.coordinate = coordinate
        
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
            let goldenHour = Solar.calculateSolarEvent(date, coordinate, Zenith.goldenHour, risingSunPosition)
            
            self.dawn = SolarEvents(sunrise,
                                    nautical: nautical,
                                    astronomical: astronomical,
                                    civil: civil,
                                    goldenHour: DateInterval(start: blueHour, end: goldenHour),
                                    blueHour: DateInterval(start: civil, end: blueHour))
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
            let goldenHour = Solar.calculateSolarEvent(date, coordinate, Zenith.goldenHour, settingSunPosition)
            
            self.dusk = SolarEvents(sunset,
                                    nautical: nautical,
                                    astronomical: astronomical,
                                    civil: civil,
                                    goldenHour: DateInterval(start: goldenHour, end: blueHour),
                                    blueHour: DateInterval(start: blueHour, end: civil))
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
    }
    
    let date: Date
    let coordinate: CLLocationCoordinate2D
    public let dawn: SolarEvents?
    public let dusk: SolarEvents?
    public let solarNoon: Date?
    public let daylight: DateInterval?
    
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
