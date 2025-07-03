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
                astronomicalDawn: Date?,
                astronomicalDusk: Date?,
                civilDawn: Date?,
                civilDusk: Date?,
                nauticalDawn: Date?,
                nauticalDusk: Date?,
                solarNoon: Date?,
                solarAngle: Double,
                morningBlueHourStart: Date?,
                morningBlueHourEnd: Date?,
                morningGoldenHourStart: Date?,
                morningGoldenHourEnd: Date?,
                eveningGoldenHourStart: Date?,
                eveningGoldenHourEnd: Date?,
                eveningBlueHourStart: Date?,
                eveningBlueHourEnd: Date?) {
        self.sunrise = sunrise
        self.sunriseAzimuth = sunriseAzimuth
        self.sunset = sunset
        self.sunsetAzimuth = sunsetAzimuth
        self.astronomicalDawn = astronomicalDawn
        self.astronomicalDusk = astronomicalDusk
        self.civilDawn = civilDawn
        self.civilDusk = civilDusk
        self.nauticalDawn = nauticalDawn
        self.nauticalDusk = nauticalDusk
        self.solarNoon = solarNoon
        self.morningBlueHourStart = morningBlueHourStart
        self.morningBlueHourEnd = morningBlueHourEnd
        self.morningGoldenHourStart = morningGoldenHourStart
        self.morningGoldenHourEnd = morningGoldenHourEnd
        self.eveningGoldenHourStart = eveningGoldenHourStart
        self.eveningGoldenHourEnd = eveningGoldenHourEnd
        self.eveningBlueHourStart = eveningBlueHourStart
        self.eveningBlueHourEnd = eveningBlueHourEnd
        self.solarAngle = solarAngle
    }
    
    public let sunrise: Date?
    public let sunriseAzimuth: Double?
    public let sunset: Date?
    public let sunsetAzimuth: Double?
    public let astronomicalDawn: Date?
    public let nauticalDawn: Date?
    public let civilDawn: Date?
    public let solarNoon: Date?
    public let civilDusk: Date?
    public let nauticalDusk: Date?
    public let astronomicalDusk: Date?
    public let morningBlueHourStart: Date?
    public let morningBlueHourEnd: Date?
    public let morningGoldenHourStart: Date?
    public let morningGoldenHourEnd: Date?
    public let eveningGoldenHourStart: Date?
    public let eveningGoldenHourEnd: Date?
    public let eveningBlueHourStart: Date?
    public let eveningBlueHourEnd: Date?
    public let solarAngle: Double
}
