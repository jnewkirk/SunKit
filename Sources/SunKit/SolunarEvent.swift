import CoreLocation
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
    
    public static func makeRange(interval: DateInterval, at: CLLocationCoordinate2D, events: Set<SolunarEventKind>) -> [SolunarEvent] {
        var results: [SolunarEvent] = []
        let coordinates = GeographicCoordinates(CLLocation(latitude: at.latitude, longitude: at.longitude))

        Solar.makeRange(interval: interval, at: coordinates, events: events, results: &results)
        Lunar.makeRange(interval: interval, at: coordinates, events: events, results: &results)

        return results.sorted(by: { $0.date < $1.date })
    }

    public var azimuth: Measurement<UnitAngle> {
        let julianDay = JulianDay(self.date)
        let sun = Sun(julianDay: julianDay)
        let horizontalCoordinates = sun.makeApparentHorizontalCoordinates(with: self.coordinates)

        return Measurement<UnitAngle>(value: horizontalCoordinates.northBasedAzimuth.value, unit: .degrees)
    }
}
