import Foundation
import SwiftAA

public struct SolunarEvent {
    public init(_ date: Date, _ kind: SolunarEventKind, _ coordinates: GeographicCoordinates) {
        self.date = date
        self.kind = kind
        self.coordinates = coordinates
    }

    public let date: Date
    public let kind: SolunarEventKind
    private let coordinates: GeographicCoordinates
    
    public var azimuth: Measurement<UnitAngle> {
        let julianDay = JulianDay(self.date)
        let sun = Sun(julianDay: julianDay)
        let horizontalCoordinates = sun.makeApparentHorizontalCoordinates(with: self.coordinates)

        return Measurement<UnitAngle>(value: horizontalCoordinates.northBasedAzimuth.value, unit: .degrees)
    }
}
