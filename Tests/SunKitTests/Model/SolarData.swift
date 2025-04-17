//
//  TestSunData.swift
//  SunKit
//
//  Copyright © 2025 James Newkirk, Brad Wilson. All rights reserved.
//

import Foundation
import CoreLocation

public struct SolarData: Codable, Sendable {
    public init(sunrise: Date?,
                sunriseAzimuth: Double?,
                sunset: Date?,
                sunsetAzimuth: Double?,
                daylight: DateInterval?,
                astronomicalDawn: Date?,
                astronomicalDusk: Date?,
                civilDawn: Date?,
                civilDusk: Date?,
                nauticalDawn: Date?,
                nauticalDusk: Date?,
                solarNoon: Date?,
                solarAngle: Double,
                morningBlueHour: DateInterval?,
                morningGoldenHour: DateInterval?,
                eveningGoldenHour: DateInterval?,
                eveningBlueHour: DateInterval?) {
        self.sunrise = sunrise
        self.sunriseAzimuth = sunriseAzimuth
        self.sunset = sunset
        self.sunsetAzimuth = sunsetAzimuth
        self.daylight = daylight
        self.astronomicalDawn = astronomicalDawn
        self.astronomicalDusk = astronomicalDusk
        self.civilDawn = civilDawn
        self.civilDusk = civilDusk
        self.nauticalDawn = nauticalDawn
        self.nauticalDusk = nauticalDusk
        self.solarNoon = solarNoon
        self.morningBlueHour = morningBlueHour
        self.morningGoldenHour = morningGoldenHour
        self.eveningGoldenHour = eveningGoldenHour
        self.eveningBlueHour = eveningBlueHour
        self.solarAngle = solarAngle
    }
    
    public let sunrise: Date?
    public let sunriseAzimuth: Double?
    public let sunset: Date?
    public let sunsetAzimuth: Double?
    public let daylight: DateInterval?
    public let astronomicalDawn: Date?
    public let nauticalDawn: Date?
    public let civilDawn: Date?
    public let solarNoon: Date?
    public let civilDusk: Date?
    public let nauticalDusk: Date?
    public let astronomicalDusk: Date?
    public let morningBlueHour: DateInterval?
    public let morningGoldenHour: DateInterval?
    public let eveningGoldenHour: DateInterval?
    public let eveningBlueHour: DateInterval?
    public let solarAngle: Double
}
