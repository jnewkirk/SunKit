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
    let actual: Date
    
    /// The nauticaul dawn or dusk event
    let nautical: Date?
    
    /// The astronomical dawn or dusk event
    let astronomical: Date?
    
    /// The civil dawn or dusk even
    let civil: Date?
    
    /// The morning or evening golden hour
    let goldenHour: DateInterval?
    
    /// The morning or evening blue hour
    let blueHour: DateInterval?
}
