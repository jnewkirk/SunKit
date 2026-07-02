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
    static let galacticCenter = EquatorialCoordinates(
        alpha: Hour(.plus, 17, 45, 40),
        delta: Degree(.minus, 29, 0, 28)
    )
}
