//
//  SolarEvents.swift
//  SunKit
//
//  Copyright © 2025 James Newkirk, Brad Wilson. All rights reserved.
//

import Foundation

public struct SolarEvents: Codable, Sendable {
    public init(_ actual: Date?, actualAzimuth: Measurement<UnitAngle>?, nautical: Date?, astronomical: Date?, civil: Date?, goldenHour: DateInterval?, blueHour: DateInterval?, interval: DateInterval?) {
        self.actual = actual
        self.actualAzimuth = actualAzimuth
        self.nautical = nautical
        self.astronomical = astronomical
        self.civil = civil
        self.goldenHour = goldenHour
        self.blueHour = blueHour
        self.interval = interval
    }
    
    /// The actual solar event (e.g., the sunrise or sunset)
    public let actual: Date?
    
    /// The azimuth angle of the sun during the actual solar event
    public let actualAzimuth: Measurement<UnitAngle>?
    
    /// The nauticaul dawn or dusk event
    public let nautical: Date?
    
    /// The astronomical dawn or dusk event
    public let astronomical: Date?
    
    /// The civil dawn or dusk even
    public let civil: Date?
    
    /// The morning or evening golden hour
    public let goldenHour: DateInterval?
    
    /// The morning or evening blue hour
    public let blueHour: DateInterval?
    
    /// the monring interval from first light to end of the golden hour - the evening interval from the start of the golden hour to astonomical dusk
    public let interval: DateInterval?
}
