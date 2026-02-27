import Foundation
import CoreLocation
import SwiftAA

struct SolunarStatus: Sendable {
    public let magicHour: MagicHour?
    public let moonIllumination: Double
    public let moonPhase: LunarPhase
    public let moonState: MoonState
    public let solarState: SolarState
}

public enum MagicHour: Sendable, CaseIterable {
    case goldenHour
    case blueHour
    
    public static func from(altitude: Double) -> MagicHour? {
        switch altitude {
        case -6.0..<(-4.0):
            return .blueHour
        case -4.0..<(6.0):
            return .goldenHour
        default:
            return nil
        }
    }}

public enum MoonState: Sendable, CaseIterable {
    case risen
    case set
}

public enum SolarState: Sendable, CaseIterable {
    case night
    case astronomicalTwilight
    case nauticalTwilight
    case civilTwilight
    case blueHourDawn
    case blueHourDusk
    case goldenHourDawn
    case goldenHourDusk
    case daylight
    
    /// Determines the sun's position based on its altitude angle in degrees and whether the sun is rising
    public static func from(altitude: Double) -> SolarState {
        switch altitude {
        case ..<(-18.0):
            return .night
        case -18.0..<(-12.0):
            return .astronomicalTwilight
        case -12.0..<(-6.0):
            return .nauticalTwilight
        case -6.0..<(-0.833):
            return .civilTwilight
        default:
            return .daylight
        }
    }
}

struct Solunar {
    public static func current(date: Date, coordinates: CLLocationCoordinate2D) -> SolunarStatus {
        let geoCoordinates = GeographicCoordinates(CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude))
        let julianDay = JulianDay(date)
        
        // Solar calculations
        let sun = Sun(julianDay: julianDay)
        let sunEquatorialCoordinates = sun.equatorialCoordinates
        let sunHorizontalCoordinates = sunEquatorialCoordinates.makeHorizontalCoordinates(
            for: geoCoordinates,
            at: julianDay
        )
        let sunAltitude = sunHorizontalCoordinates.altitude.value
        
        // Moon calculations
        let moon = Moon(julianDay: julianDay)
        let moonEquatorialCoordinates = moon.equatorialCoordinates
        let moonHorizontalCoordinates = moonEquatorialCoordinates.makeHorizontalCoordinates(
            for: geoCoordinates,
            at: julianDay
        )
        let moonAltitude = moonHorizontalCoordinates.altitude.value
        let moonState: MoonState = moonAltitude > 0 ? .risen : .set
        let moonIllumination = moon.illuminatedFraction()
        let moonAge = moonAge(julianDay: julianDay)
        let lunarPhase = lunarPhase(moonAge: moonAge)
        
        return SolunarStatus(
            magicHour: MagicHour.from(altitude: sunAltitude),
            moonIllumination: moonIllumination,
            moonPhase: lunarPhase,
            moonState: moonState,
            solarState: SolarState.from(altitude: sunAltitude)
        )
    }
    
    static func moonAge(julianDay: JulianDay) -> Double {
        // Known new moon date (January 6, 2000 at 18:14 UTC)
        let knownNewMoonJD = 2451550.26
        
        var age = fmod(julianDay.value - knownNewMoonJD, Constant.synodicMonth)
        if age < 0 {
            age += Constant.synodicMonth
        }
        return age
    }
    
    static func lunarPhase(moonAge: Double) -> LunarPhase {
        if moonAge < Constant.lunarFirstQuarter {
            return .waxingCrescent
        }
        if moonAge < Constant.lunarFull {
            return .waxingGibbous
        }
        if moonAge < Constant.lunarThirdQuarter {
            return .waningGibbous
        }
        
        return .waningCrescent
    }
}
