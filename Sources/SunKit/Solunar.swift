import Foundation
import CoreLocation
import SwiftAA

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
