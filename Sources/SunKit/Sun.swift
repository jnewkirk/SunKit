//
//  Sun.swift
//  SunKit
//
//  Created by James Newkirk on January, 23. 2025.
//  Copyright © 2025 James Newkirk, Brad Wilson. All rights reserved.
//

import Foundation
import CoreLocation

public struct Sun: Codable, Sendable {
    public init(for date: Date,
                  coordinate: CLLocationCoordinate2D,
                  sunrise: Date?,
                  sunset: Date?,
                  astronomicalDawn: Date?,
                  astronomicalDusk: Date?,
                  civilDawn: Date?,
                  civilDusk: Date?,
                  nauticalDawn: Date?,
                  nauticalDusk: Date?,
                  solarNoon: Date?,
                  solarMidnight: Date?,
                  morningBlueHour: DateInterval?,
                  morningGoldenHour: DateInterval?,
                  eveningGoldenHour: DateInterval?,
                  eveningBlueHour: DateInterval?) {
        self.inputDate = date
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        
        self.sunrise = sunrise
        self.sunset = sunset
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
    }
    
    let inputDate: Date
    let latitude: Double
    let longitude: Double
    public let sunrise: Date?
    public let sunset: Date?
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
    
    public var isDaylight: Bool {
        return false
    }
}

/*
 Additions
 
 Total Daylight - 11hrs 21min
 
 Given a time - what is the angle of the sun
 
 isDaylight
 
 */
