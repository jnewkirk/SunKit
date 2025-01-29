//
//  TestSunData.swift
//  SunKit
//
//  Created by Jim Newkirk on 1/29/25.
//

import Foundation
import CoreLocation

public struct TestSunData: Codable, Sendable {
    public init(for date: Date,
                coordinate: CLLocationCoordinate2D,
                sunrise: Date?,
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
                morningBlueHour: DateInterval?,
                morningGoldenHour: DateInterval?,
                eveningGoldenHour: DateInterval?,
                eveningBlueHour: DateInterval?) {
        self.inputDate = date
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        
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
    }
    
    let inputDate: Date
    let latitude: Double
    let longitude: Double
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
    
    public var isDaylight: Bool {
        guard let daylight else {
            return false
        }
        
        return daylight.contains(self.inputDate)
    }
}

/*
 Additions
 
 Given a time - what is the angle of the sun
 
 
 */
