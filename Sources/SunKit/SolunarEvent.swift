import CoreLocation
import Foundation
@preconcurrency import SwiftAA

public struct SolunarEvent : Codable, Sendable {
    public let date: Date
    public let kind: SolunarEventKind
    public let azimuthAngleInDegrees: Double
    
    public init(_ date: Date, _ kind: SolunarEventKind, _ coordinates: GeographicCoordinates) {
        self.date = date
        self.kind = kind

        let julianDay = JulianDay(self.date)

        let equatorialCoordinates: EquatorialCoordinates
        switch kind {
        case .moonrise, .moonApex, .moonset,
             .newMoon, .firstQuarter, .fullMoon, .lastQuarter:
            equatorialCoordinates = Moon(julianDay: julianDay).equatorialCoordinates

        case .galacticCenterRise, .galacticCenterApex, .galacticCenterSet:
                equatorialCoordinates = Constant.galacticCenter

        default:
            equatorialCoordinates = Sun(julianDay: julianDay).equatorialCoordinates
        }

        let horizontalCoordinates = equatorialCoordinates.makeHorizontalCoordinates(
            for: coordinates,
            at: julianDay
        )

        self.azimuthAngleInDegrees = horizontalCoordinates.northBasedAzimuth.value
    }
}
