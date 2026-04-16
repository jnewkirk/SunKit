import Foundation
import SwiftAA

struct SolarCalculator : SolunarCalculator {
    private init(_ angle: Measurement<UnitAngle>, _ riseSet: RiseTransitSetState) {
        self.angle = angle
        self.riseSet = riseSet
    }

    let angle: Measurement<UnitAngle>
    let riseSet: RiseTransitSetState
    var degrees: Degree { Degree(angle.converted(to: .degrees).value) }

    public func calculate(interval: DateInterval, coordinates: GeographicCoordinates) -> Date? {
        let intervalJulianDay = JulianDay(interval.start)
        return computeRiseSet(julianDay: intervalJulianDay, interval: interval, coordinates: coordinates)
    }

    private func computeRiseSet(julianDay: JulianDay, interval: DateInterval, coordinates: GeographicCoordinates) -> Date? {
        let riseSetYesterday = Earth(julianDay: julianDay - 1).twilights(forSunAltitude: degrees, coordinates: coordinates)
        let riseSetToday = Earth(julianDay: julianDay).twilights(forSunAltitude: degrees, coordinates: coordinates)
        let riseSetTomorrow = Earth(julianDay: julianDay + 1).twilights(forSunAltitude: degrees, coordinates: coordinates)

        switch riseSet {
        case .rise:
            return interval.inDateInterval(dates: [riseSetYesterday.riseTime?.date, riseSetToday.riseTime?.date, riseSetTomorrow.riseTime?.date])?.toNearestMinute()
        case .transit:
            return interval.inDateInterval(dates: [riseSetYesterday.transitTime?.date, riseSetToday.transitTime?.date, riseSetTomorrow.transitTime?.date])?.toNearestMinute()
        case .set:
            return interval.inDateInterval(dates: [riseSetYesterday.setTime?.date, riseSetToday.setTime?.date, riseSetTomorrow.setTime?.date])?.toNearestMinute()
        }
    }
}

extension SolarCalculator {
    internal static let goldenHour = Measurement<UnitAngle>(value: 6.0, unit: .degrees)
    internal static let official = Measurement<UnitAngle>(value: TwilightSunAltitude.upperLimbOnHorizonWithRefraction.rawValue.value, unit: .degrees)
    internal static let blueHour = Measurement<UnitAngle>(value: -4.0, unit: .degrees)
    internal static let civil = Measurement<UnitAngle>(value: TwilightSunAltitude.civilian.rawValue.value, unit: .degrees)
    internal static let nautical = Measurement<UnitAngle>(value: TwilightSunAltitude.nautical.rawValue.value, unit: .degrees)
    internal static let astronomical = Measurement<UnitAngle>(value: TwilightSunAltitude.astronomical.rawValue.value, unit: .degrees)
    
    /// This marks the sunrise, when the sun is 0.833 degrees below the horizon and rising
    public static let sunrise = SolarCalculator(Self.official, .rise)

    /// This gets the transit time of the sun, which is the midpoint
    public static let solarNoon = SolarCalculator(Self.official, .transit)

    /// This marks the sunset, when the sun is 0.833 degrees below the horizing and setting
    public static let sunset = SolarCalculator(Self.official, .set)
    
    /// This marks civil dawn, when the sun is 6.0 degrees below the horizon
    public static let civilDawn = SolarCalculator(Self.civil, .rise)
    
    /// This marks civil dusk, when the sun is 6.0 degrees below the horizon
    public static let civilDusk = SolarCalculator(Self.civil, .set)
    
    /// This marks nautical dawn, when the sun is 12.0 degrees below the horizon
    public static let nauticalDawn = SolarCalculator(Self.nautical, .rise)
    
    /// This marks nautical dusk, when the sun is 12.0 degrees below the horizon
    public static let nauticalDusk = SolarCalculator(Self.nautical, .set)
    
    /// This marks astronomical dawn, when the sun is 18.0 degrees below the horizon
    public static let astronomicalDawn = SolarCalculator(Self.astronomical, .rise)
    
    /// This marks astronomical dusk, when the sun is 18.0 degrees below the horizon
    public static let astronomicalDusk = SolarCalculator(Self.astronomical, .set)
    
    /// This marks the end of the blue hour for dawn (which started at civil dawn), when the sun is at 4.0 degrees below the horizon
    public static let blueHourEndDawn = SolarCalculator(Self.blueHour, .rise)
    
    /// This marks the start of the blue hour for dusk (which ends at civil dusk), when the sun is at 4.0 degrees below the horizon
    public static let blueHourStartDusk = SolarCalculator(Self.blueHour, .set)
    
    /// This marks the end of the golden hour for dawn (which started at blue hour for dawn), when the sun is 6.0 degrees above the horizon
    public static let goldenHourEndDawn = SolarCalculator(Self.goldenHour, .rise)
    
    /// This marks the start of the golden hour for dusk (which ends at blue hour for dusk), when the sun is 6.0 degrees above the horizon
    public static let goldenHourStartDusk = SolarCalculator(Self.goldenHour, .set)
}
