import Foundation
import CoreLocation
import SwiftAA

public struct Solunar {
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
        let moonState: LunarState = moonAltitude > 0 ? .risen : .set
        
        // Galactic Center calculations
        // RA: 17h 45m 40.04s, Dec: -29° 00' 28.1" (J2000)
        let galacticCenterEquatorialCoordinates = EquatorialCoordinates(
            alpha: Hour(.plus, 17, 45, 40),
            delta: Degree(.minus, 29, 0, 28)
        )
        let galacticCenterHorizontalCoordinates = galacticCenterEquatorialCoordinates.makeHorizontalCoordinates(
            for: geoCoordinates,
            at: julianDay
        )
        let galacticCenterAltitude = galacticCenterHorizontalCoordinates.altitude.value
        let galacticCenterState: LunarState = galacticCenterAltitude > -0.5667 ? .risen : .set
        
        let moonIllumination = moon.illuminatedFraction()
        let lunarPhase = LunarPhase.current(julianDay: julianDay)
        
        return SolunarStatus(
            magicHour: MagicHour.from(altitude: sunAltitude),
            moonIllumination: moonIllumination,
            moonPhase: lunarPhase,
            moonState: moonState,
            solarState: SolarState.from(altitude: sunAltitude),
            galacticCenterState: galacticCenterState
        )
    }
    
    public static func getEvents(interval: DateInterval,
                                 coordinates: CLLocationCoordinate2D,
                                 events: [SolunarEventKind]) -> [SolunarEvent] {
        let geoCoordinates = GeographicCoordinates(CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude))
        
        var results: [SolunarEvent] = []
        for event in events {
            getEvents(interval: interval, coordinates: geoCoordinates, event: event, results: &results)
        }
        return results.sorted(by: {
            if $0.date == $1.date {
                return $0.kind.rawValue < $1.kind.rawValue
            }
            return $0.date < $1.date
        })
    }
    
    static func getEvents(interval: DateInterval,
                          coordinates: GeographicCoordinates,
                          event: SolunarEventKind,
                          results: inout [SolunarEvent]) {
        guard let calculator = event.calculator() else { return }
        
        var currentInterval = interval
        while true {
            if let date = calculator.calculate(interval: currentInterval, coordinates: coordinates) {
                results.append(SolunarEvent(date, event, coordinates))
                let newStart = date.add(minutes: 5)
                if newStart > currentInterval.end {
                    break
                }
                currentInterval = DateInterval(start: newStart, end: currentInterval.end)
            } else {
                break
            }
        }
    }
    
    private static func computeRiseSet(riseSet: RiseTransitSetState, degree: Degree, interval: DateInterval, coordinates: GeographicCoordinates) -> Date? {
        let intervalJulianDay = JulianDay(interval.start)
        
        return computeRiseSet(riseSet: riseSet, julianDay: intervalJulianDay, interval: interval, coordinates: coordinates, degree: degree)
    }
    
    private static func computeRiseSet(riseSet: RiseTransitSetState, julianDay: JulianDay, interval: DateInterval, coordinates: GeographicCoordinates, degree: Degree) -> Date? {
        let riseSetYesterday = Earth(julianDay: julianDay - 1).twilights(forSunAltitude: degree, coordinates: coordinates)
        let riseSetToday = Earth(julianDay: julianDay).twilights(forSunAltitude: degree, coordinates: coordinates)
        let riseSetTomorrow = Earth(julianDay: julianDay + 1).twilights(forSunAltitude: degree, coordinates: coordinates)

        if riseSet == .rise {
            return interval.inDateInterval(dates: [riseSetYesterday.riseTime?.date, riseSetToday.riseTime?.date, riseSetTomorrow.riseTime?.date])?.toNearestMinute()
        } else {
            return interval.inDateInterval(dates: [riseSetYesterday.setTime?.date, riseSetToday.setTime?.date, riseSetTomorrow.setTime?.date])?.toNearestMinute()
        }
    }
}
