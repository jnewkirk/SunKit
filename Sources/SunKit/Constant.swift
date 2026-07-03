import Foundation
@preconcurrency import SwiftAA

struct Constant {
    static var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = Constant.utcTimezone
        return calendar
    }

    public static let utcTimezone = TimeZone(identifier: "UTC")!

    // Sagittarius A* (Galactic Center), J2000 — RA 17h 45m 40s, Dec -29° 00' 28"
    static let galacticCenterJ2000 = EquatorialCoordinates(
        alpha: Hour(.plus, 17, 45, 40),
        delta: Degree(.minus, 29, 0, 28)
    )

    // Sag A* precessed to the mean equinox of the given date.
    static func precessedGalacticCenter(on julianDay: JulianDay) -> EquatorialCoordinates {
        galacticCenterJ2000.precessedCoordinates(to: .meanEquinoxOfTheDate(julianDay))
    }
}
