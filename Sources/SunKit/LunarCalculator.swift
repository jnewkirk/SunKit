import Foundation
import SwiftAA

struct LunarCalculator : SolunarCalculator {
    internal init(_ kind: SolunarEventKind) {
        self.kind = kind
    }
    
    let kind: SolunarEventKind

    public func calculate(interval: DateInterval, coordinates: GeographicCoordinates) -> Date? {
        switch kind {
        case .moonrise:
            return Self.moonRiseAndSet(interval: interval, coordinates: coordinates).rise
        case .moonApex:
            return Self.moonRiseAndSet(interval: interval, coordinates: coordinates).transit
        case .moonset:
            return Self.moonRiseAndSet(interval: interval, coordinates: coordinates).set
        case .galacticCenterRise:
            return Self.galacticCenterRiseSet(interval: interval, coordinates: coordinates).rise
        case .galacticCenterApex:
            return Self.galacticCenterRiseSet(interval: interval, coordinates: coordinates).transit
        case .galacticCenterSet:
            return Self.galacticCenterRiseSet(interval: interval, coordinates: coordinates).set
        default:
            return nil
        }
    }

    static func galacticCenterRiseSet(interval: DateInterval, coordinates: GeographicCoordinates) -> RiseTransitSet {
        let julianDay = JulianDay(interval.start).midnight

        // Sagittarius A* (Galactic Center) fixed coordinates (J2000)
        // RA: 17h 45m 40s, Dec: -29° 00' 28"
        let rightAscension = Hour(.plus, 17, 45, 40)   // 17.761111 hours
        let declination = Degree(.minus, 29, 0, 28)    // -29.007778 degrees

        // Create fixed equatorial coordinates for Sagittarius A*
        let galacticCenter = EquatorialCoordinates(alpha: rightAscension, delta: declination)

        // Standard altitude for stars and planets
        let apparentRiseSetAltitude = Degree(-0.5667)  // -34 arcminutes

        // Calculate for yesterday, today, and tomorrow
        // Since Sagittarius A* is a fixed star, coordinates don't change
        let riseSetYesterday = riseTransitSet(
            forJulianDay: julianDay - 1,
            equCoords1: galacticCenter,
            equCoords2: galacticCenter,
            equCoords3: galacticCenter,
            geoCoords: coordinates,
            apparentRiseSetAltitude: apparentRiseSetAltitude
        )

        let riseSetToday = riseTransitSet(
            forJulianDay: julianDay,
            equCoords1: galacticCenter,
            equCoords2: galacticCenter,
            equCoords3: galacticCenter,
            geoCoords: coordinates,
            apparentRiseSetAltitude: apparentRiseSetAltitude
        )

        let riseSetTomorrow = riseTransitSet(
            forJulianDay: julianDay + 1,
            equCoords1: galacticCenter,
            equCoords2: galacticCenter,
            equCoords3: galacticCenter,
            geoCoords: coordinates,
            apparentRiseSetAltitude: apparentRiseSetAltitude
        )

        // Find which date falls within the interval
        let rise = interval.inDateInterval(dates: [
            riseSetYesterday.isRiseValid ? riseSetYesterday.riseTime.date : nil,
            riseSetToday.isRiseValid ? riseSetToday.riseTime.date : nil,
            riseSetTomorrow.isRiseValid ? riseSetTomorrow.riseTime.date : nil
        ])
        let transit = interval.inDateInterval(dates: [
            riseSetYesterday.isTransitAboveHorizon ? riseSetYesterday.transitTime.date : nil,
            riseSetToday.isTransitAboveHorizon ? riseSetToday.transitTime.date : nil,
            riseSetTomorrow.isTransitAboveHorizon ? riseSetTomorrow.transitTime.date : nil
        ])
        let set = interval.inDateInterval(dates: [
            riseSetYesterday.isSetValid ? riseSetYesterday.setTime.date : nil,
            riseSetToday.isSetValid ? riseSetToday.setTime.date : nil,
            riseSetTomorrow.isSetValid ? riseSetTomorrow.setTime.date : nil
        ])

        return RiseTransitSet(rise: rise?.toNearestMinute(), transit: transit?.toNearestMinute(), set: set?.toNearestMinute())
    }

    private static func moonRiseAndSet(interval: DateInterval, coordinates: GeographicCoordinates) -> RiseTransitSet {
        let julianDay = JulianDay(interval.start)

        let moonToday = Moon(julianDay: julianDay)

        let riseSetYesterday = Moon(julianDay: julianDay - 1).riseTransitSetTimes(for: coordinates)
        let riseSetToday = moonToday.riseTransitSetTimes(for: coordinates)
        let riseSetTomorrow = Moon(julianDay: julianDay + 1).riseTransitSetTimes(for: coordinates)

        let rise = interval.inDateInterval(dates: [riseSetYesterday.riseTime?.date, riseSetToday.riseTime?.date, riseSetTomorrow.riseTime?.date])
        let transit = interval.inDateInterval(dates: [riseSetYesterday.transitTime?.date, riseSetToday.transitTime?.date, riseSetTomorrow.transitTime?.date])
        let set = interval.inDateInterval(dates: [riseSetYesterday.setTime?.date, riseSetToday.setTime?.date, riseSetTomorrow.setTime?.date])

        return RiseTransitSet(rise: rise?.toNearestMinute(), transit: transit?.toNearestMinute(), set: set?.toNearestMinute())
    }
}

extension LunarCalculator {
    public static let moonrise = LunarCalculator(.moonrise)
    public static let moonApex = LunarCalculator(.moonApex)
    public static let moonset = LunarCalculator(.moonset)
    public static let galacticCenterRise = LunarCalculator(.galacticCenterRise)
    public static let galacticCenterApex = LunarCalculator(.galacticCenterApex)
    public static let galacticCenterSet = LunarCalculator(.galacticCenterSet)
}
