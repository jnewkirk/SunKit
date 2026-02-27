import Foundation
import CoreLocation
import Testing
@testable import SunKit

struct SolunarTests {
    struct MagicHour {
        @Test
        func goldenHourDawn() throws {
            // 6:32a - 7:33a
            let solunarStatus = Solunar.current(
                date: "2026-02-27T14:53:00Z".toDate()!,
                coordinates: Constant.puyallup
            )
            
            #expect (solunarStatus.magicHour == .goldenHour)
        }
        
        @Test
        func goldenHourDusk() throws {
            // 5:09p - 6:09p
            let solunarStatus = Solunar.current(
                date: "2026-02-28T01:30:00Z".toDate()!,
                coordinates: Constant.puyallup
            )
            
            #expect (solunarStatus.magicHour == .goldenHour)
        }
        
        @Test
        func blueHourDawn() throws {
            // 6:20a - 6:32a
            let solunarStatus = Solunar.current(
                date: "2026-02-27T14:26:00Z".toDate()!,
                coordinates: Constant.puyallup
            )
            
            #expect (solunarStatus.magicHour == .blueHour)
        }
        
        @Test
        func blueHourDusk() throws {
            // 6:09p - 6:21p
            let solunarStatus = Solunar.current(
                date: "2026-02-28T02:13:00Z".toDate()!,
                coordinates: Constant.puyallup
            )
            
            #expect (solunarStatus.magicHour == .blueHour)
        }

        @Test
        func nighttime() throws {
            let solunarStatus = Solunar.current(
                date: "2026-02-27T14:18:00Z".toDate()!,
                coordinates: Constant.puyallup
            )
            
            #expect (solunarStatus.magicHour == nil)
        }

        @Test
        func daytime() throws {
            let solunarStatus = Solunar.current(
                date: "2026-02-27T15:35:00Z".toDate()!,
                coordinates: Constant.puyallup
            )
            
            #expect (solunarStatus.magicHour == nil)
        }
    }
    
    struct SolarState {
        @Test
        func night() throws {
            // Middle of the night, well past astronomical twilight
            let solunarStatus = Solunar.current(
                date: "2026-02-27T10:00:00Z".toDate()!,
                coordinates: Constant.puyallup
            )
            
            #expect (solunarStatus.solarState == .night)
        }
        
        @Test
        func astronomicalTwilight() throws {
            // Early morning during astronomical twilight
            let solunarStatus = Solunar.current(
                date: "2026-02-27T13:25:00Z".toDate()!,
                coordinates: Constant.puyallup
            )
            
            #expect (solunarStatus.solarState == .astronomicalTwilight)
        }
        
        @Test
        func nauticalTwilight() throws {
            // Morning during nautical twilight
            let solunarStatus = Solunar.current(
                date: "2026-02-27T14:00:00Z".toDate()!,
                coordinates: Constant.puyallup
            )
            
            #expect (solunarStatus.solarState == .nauticalTwilight)
        }
        
        @Test
        func civilTwilight() throws {
            // Shortly before sunrise during civil twilight
            let solunarStatus = Solunar.current(
                date: "2026-02-27T14:30:00Z".toDate()!,
                coordinates: Constant.puyallup
            )
            
            #expect (solunarStatus.solarState == .civilTwilight)
        }
        
        @Test
        func daylight() throws {
            // Mid-day
            let solunarStatus = Solunar.current(
                date: "2026-02-27T21:00:00Z".toDate()!,
                coordinates: Constant.puyallup
            )
            
            #expect (solunarStatus.solarState == .daylight)
        }
    }
    
    struct MoonState {
        @Test
        func risen() throws {
            // A couple minutes after moonrise
            let solunarStatus = Solunar.current(
                date: "2026-02-27T21:25:00Z".toDate()!,
                coordinates: Constant.puyallup
            )
            
            #expect (solunarStatus.moonState == .risen)
        }
        
        @Test
        func set() throws {
            // Several minutes before moonrise
            let solunarStatus = Solunar.current(
                date: "2026-02-27T21:10:00Z".toDate()!,
                coordinates: Constant.puyallup
            )
            
            #expect (solunarStatus.moonState == .set)
        }
    }
    
    struct MoonIllumination {
        @Test
        func illumination() {
            let solunarStatus = Solunar.current(
                date: "2026-02-27T21:10:00Z".toDate()!,
                coordinates: Constant.puyallup
            )
            
            #expect(85 == (solunarStatus.moonIllumination * 100).rounded())
        }
    }
    
    struct MoonPhase {
        @Test
        func waxingGibbous() {
            let solunarStatus = Solunar.current(
                date: "2026-02-27T21:10:00Z".toDate()!,
                coordinates: Constant.puyallup
            )
            
            #expect(.waxingGibbous == solunarStatus.moonPhase)
        }

        @Test
        func waningGibbous() {
            let solunarStatus = Solunar.current(
                date: "2026-03-04T21:10:00Z".toDate()!,
                coordinates: Constant.puyallup
            )
            
            #expect(.waningGibbous == solunarStatus.moonPhase)
        }

        @Test
        func waningCrescent() {
            let solunarStatus = Solunar.current(
                date: "2026-03-12T21:10:00Z".toDate()!,
                coordinates: Constant.puyallup
            )
            
            #expect(.waningCrescent == solunarStatus.moonPhase)
        }

        @Test
        func waxingCrescent() {
            let solunarStatus = Solunar.current(
                date: "2026-03-20T21:10:00Z".toDate()!,
                coordinates: Constant.puyallup
            )
            
            #expect(.waxingCrescent == solunarStatus.moonPhase)
        }
    }
}
