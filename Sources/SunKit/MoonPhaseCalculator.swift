import Foundation
import SwiftAA

struct MoonPhaseCalculator : SolunarCalculator {
    private init(_ kind: SolunarEventKind) {
        self.kind = kind
    }

    let kind: SolunarEventKind

    public static let newMoon: MoonPhaseCalculator = MoonPhaseCalculator(.newMoon)
    public static let firstQuarter: MoonPhaseCalculator = MoonPhaseCalculator(.firstQuarter)
    public static let fullMoon: MoonPhaseCalculator = MoonPhaseCalculator(.fullMoon)
    public static let lastQuarter: MoonPhaseCalculator = MoonPhaseCalculator(.lastQuarter)

    func calculate(interval: DateInterval, coordinates: GeographicCoordinates) -> Date? {
        let searchMoon = Moon(julianDay: JulianDay(interval.start))
        let end = JulianDay(interval.end)
        let next = searchMoon.time(of: moonPhase, mean: false)
        if next < end {
            return next.date.toNearestMinute()
        }
        return nil
    }

    var moonPhase: MoonPhase {
        switch kind {
        case .newMoon:
            return .newMoon
        case .firstQuarter:
            return .firstQuarter
        case .fullMoon:
            return .fullMoon
        default:
            return .lastQuarter
        }
    }
}
