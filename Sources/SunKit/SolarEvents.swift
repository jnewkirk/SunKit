//
//  SolarEvents.swift
//  SunKit
//
//  Created by Jim Newkirk on 1/29/25.
//

import Foundation

public struct SolarEvents: Sendable {
    public init(_ actual: Date, nautical: Date? = nil, astronomical: Date? = nil, civil: Date? = nil, goldenHour: DateInterval? = nil, blueHour: DateInterval? = nil) {
        self.actual = actual
        self.nautical = nautical
        self.astronomical = astronomical
        self.civil = civil
        self.goldenHour = goldenHour
        self.blueHour = blueHour
    }
    
    /// The actual solar event (e.g., the sunrise or sunset)
    public let actual: Date
    
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
}
