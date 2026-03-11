import Foundation
import SwiftAA

protocol SolunarCalculator : Sendable {
    func calculate(interval: DateInterval, coordinates: GeographicCoordinates) -> Date?
}
