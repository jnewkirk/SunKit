//
//  TestSunData.swift
//  SunKit
//
//  Copyright © 2025 James Newkirk, Brad Wilson. All rights reserved.
//

import Foundation
import CoreLocation

public struct TestSunData: Codable, Sendable {
    public init(sunrise: Date?,
                sunset: Date?,
                daylight: DateInterval?,
                astronomicalDawn: Date?,
                astronomicalDusk: Date?,
                civilDawn: Date?,
                civilDusk: Date?,
                nauticalDawn: Date?,
                nauticalDusk: Date?,
                solarNoon: Date?,
                solarMidnight: Date?,
                solarAngle: Double,
                morningBlueHour: DateInterval?,
                morningGoldenHour: DateInterval?,
                eveningGoldenHour: DateInterval?,
                eveningBlueHour: DateInterval?) {
        self.sunrise = sunrise
        self.sunset = sunset
        self.daylight = daylight
        self.astronomicalDawn = astronomicalDawn
        self.astronomicalDusk = astronomicalDusk
        self.civilDawn = civilDawn
        self.civilDusk = civilDusk
        self.nauticalDawn = nauticalDawn
        self.nauticalDusk = nauticalDusk
        self.solarNoon = solarNoon
        self.solarMidnight = solarMidnight
        self.morningBlueHour = morningBlueHour
        self.morningGoldenHour = morningGoldenHour
        self.eveningGoldenHour = eveningGoldenHour
        self.eveningBlueHour = eveningBlueHour
        self.solarAngle = solarAngle
    }
    
    public let sunrise: Date?
    public let sunset: Date?
    public let daylight: DateInterval?
    public let astronomicalDawn: Date?
    public let nauticalDawn: Date?
    public let civilDawn: Date?
    public let solarNoon: Date?
    public let civilDusk: Date?
    public let nauticalDusk: Date?
    public let astronomicalDusk: Date?
    public let solarMidnight: Date?
    public let morningBlueHour: DateInterval?
    public let morningGoldenHour: DateInterval?
    public let eveningGoldenHour: DateInterval?
    public let eveningBlueHour: DateInterval?
    public let solarAngle: Double
}
