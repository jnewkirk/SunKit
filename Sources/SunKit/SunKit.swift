//
//  SunKit.swift
//  SunKit
//
//  Created by Jim Newkirk on 1/22/25.
//

import Foundation
import CoreLocation

public struct SunKit {
    let calendar: Calendar
    let coordinate: CLLocationCoordinate2D
    
    init?(_ coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        
        guard let utcTimezone = TimeZone(identifier: "UTC") else { return nil }
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = utcTimezone
        self.calendar = calendar
    }
    
    public func monkey(_ date: Date) -> Sun {
        let dayOfTheYear = Double(calendar.ordinality(of: .day, in: .year, for: date)!)
        let longitudinalHour = coordinate.longitude / 15
        let risingSunPosition = calculcateSunPosition(isSunrise: true, dayOfTheYear: dayOfTheYear, longitudinalHour: longitudinalHour)
        let settingSunPosition = calculcateSunPosition(isSunrise: false, dayOfTheYear: dayOfTheYear, longitudinalHour: longitudinalHour)
        
        let civilDawn = calculateSolarEvent(date: date, zenith: Zenith.civil, sunPosition: risingSunPosition)
        let risingBlueHour = calculateSolarEvent(date: date, zenith: Zenith.blueHour, sunPosition: risingSunPosition)
        let risingGoldenHour = calculateSolarEvent(date: date, zenith: Zenith.goldenHour, sunPosition: risingSunPosition)
        
        let civilDusk = calculateSolarEvent(date: date, zenith: Zenith.civil, sunPosition: settingSunPosition)
        let settingGoldenHour = calculateSolarEvent(date: date, zenith: Zenith.goldenHour, sunPosition: settingSunPosition)
        let settingBlueHour = calculateSolarEvent(date: date, zenith: Zenith.blueHour, sunPosition: settingSunPosition)

        return Sun(
            for: date,
            coordinate: coordinate,
            sunrise: calculateSolarEvent(date: date, zenith: Zenith.official, sunPosition: risingSunPosition),
            sunset: calculateSolarEvent(date: date, zenith: Zenith.official, sunPosition: settingSunPosition),
            astronomicalDawn: calculateSolarEvent(date: date, zenith: Zenith.astronimical, sunPosition: risingSunPosition),
            astronomicalDusk: calculateSolarEvent(date: date, zenith: Zenith.astronimical, sunPosition: settingSunPosition),
            civilDawn: civilDawn,
            civilDusk: civilDusk,
            nauticalDawn: calculateSolarEvent(date: date, zenith: Zenith.nautical, sunPosition: risingSunPosition),
            nauticalDusk: calculateSolarEvent(date: date, zenith: Zenith.nautical, sunPosition: settingSunPosition),
            solarNoon: nil,
            solarMidnight: nil,
            morningBlueHour: getDateInterval(start: civilDawn, end: risingBlueHour),
            morningGoldenHour: getDateInterval(start: risingBlueHour, end: risingGoldenHour),
            eveningGoldenHour: getDateInterval(start: settingGoldenHour, end: settingBlueHour),
            eveningBlueHour: getDateInterval(start: settingBlueHour, end: civilDusk)
        )
    }
    
    fileprivate struct SunPosition {
        let isSunrise: Bool
        let time: Double
        let sunDeclinationSineRadians: Double
        let rightAscensionHours: Double
        let longitudinalHour: Double
    }
    
    fileprivate func getDateInterval(start: Date?, end: Date?) -> DateInterval? {
        guard let start else { return nil }
        guard let end else { return nil }
        
        return DateInterval(start: start, end: end)
    }
    
    fileprivate func calculcateSunPosition(isSunrise: Bool, dayOfTheYear: Double, longitudinalHour: Double) -> SunPosition {
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
    
    fileprivate func calculateSolarEvent(date: Date, zenith: Zenith, sunPosition: SunPosition) -> Date? {
        let localHourAngleCosine = calculateLocalHourAngleCosine(zenith.rawValue, sunPosition.sunDeclinationSineRadians, sunPosition.rightAscensionHours)
        if (localHourAngleCosine > 1 || localHourAngleCosine < -1) {
            return nil
        }
        
        let hourUTC = calculateHourUTC(isSunrise: sunPosition.isSunrise, sunPosition.time, localHourAngleCosine, sunPosition.rightAscensionHours, sunPosition.longitudinalHour)
        return calculateDate(from: date, offsetBy: hourUTC, isSunrise: sunPosition.isSunrise, sunPosition.longitudinalHour)
    }
    
    fileprivate func calculateHourUTC(isSunrise: Bool, _ time: Double, _ localHourAngleCosine: Double, _ rightAscensionHours: Double, _ longitudinalHour: Double) -> Double {
        let hour: Double
        if (isSunrise) {
            hour = (360 - acos(localHourAngleCosine).radiansToDegrees)
        } else {
            hour = acos(localHourAngleCosine).radiansToDegrees
        }
        
        let localMeanTime = (hour / 15) + rightAscensionHours - (0.06571 * time) - 6.622
        
        return normalizeHour(localMeanTime - longitudinalHour)
    }
    
    fileprivate func calculateDate(from: Date, offsetBy: Double, isSunrise: Bool, _ longitudinalHour: Double) -> Date? {
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
        
        var components = calendar.dateComponents([.day, .month, .year], from: setDate)
        components.hour = Int(hourComponent)
        components.minute = Int(minuteComponent)
        components.second = Int(secondComponent)
        
        return calendar.date(from: components)
    }
    
    fileprivate func calculateLocalHourAngleCosine(_ zenith: Double, _ sunDeclinationSineRadians: Double, _ rightAscensionHours: Double) -> Double {
        let sunDeclinationCosineRadians = cos(asin(sunDeclinationSineRadians))
        
        return (cos(zenith.degreesToRadians) - (sunDeclinationSineRadians * sin(coordinate.latitude.degreesToRadians))) / (sunDeclinationCosineRadians * cos(coordinate.latitude.degreesToRadians))
    }
    
    fileprivate func normalizeDegrees(_ value: Double) -> Double {
        return normalize(value, max: 360)
    }
    
    fileprivate func normalizeHour(_ value: Double) -> Double {
        return normalize(value, max: 24)
    }
    
    fileprivate func normalize(_ value: Double, max: Double) -> Double {
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

private extension Double {
    var degreesToRadians: Double {
        return Double(self) * (Double.pi / 180.0)
    }
    
    var radiansToDegrees: Double {
        return (Double(self) * 180.0) / Double.pi
    }
}
