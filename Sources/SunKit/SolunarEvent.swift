import CoreLocation
import Foundation
@preconcurrency import SwiftAA

public struct SolunarEvent : Codable, Sendable {
    public init(_ date: Date, _ kind: SolunarEventKind, _ coordinates: GeographicCoordinates) {
        self.date = date
        self.kind = kind
        
        let julianDay = JulianDay(self.date)
        let sun = Sun(julianDay: julianDay)
        let horizontalCoordinates = sun.makeApparentHorizontalCoordinates(with: coordinates)

        self.azimuthAngleInDegrees = horizontalCoordinates.northBasedAzimuth.value
    }

    // TODO: This should have an angle, useful for sunrise/sunset/moonrise/moonset/galatic center
    public let date: Date
    public let kind: SolunarEventKind
    public let azimuthAngleInDegrees: Double
}
