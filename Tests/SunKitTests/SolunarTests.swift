import Foundation
import CoreLocation
import Testing
@testable import SunKit

struct SolunarTests {
    struct MagicHour {
        var testSolarData: [TestSolarData] = []
        
        internal init() {
            testSolarData = TestSolarData.load()
        }
        
        @Test
        func goldenHourDawn() throws {
            for testLocation in testSolarData {
                if let start = testLocation.solarData.morningGoldenHourStart, let end = testLocation.solarData.morningGoldenHourEnd {
                    let solunarStatus = Solunar.current(
                        date: start.midpoint(end),
                        coordinates: testLocation.waypoint.coordinate
                    )
                    #expect (solunarStatus.magicHour == .goldenHour)
                }
            }
        }
        
        @Test
        func goldenHourDusk() throws {
            for testLocation in testSolarData {
                if let start = testLocation.solarData.eveningGoldenHourStart, let end = testLocation.solarData.eveningGoldenHourEnd {
                    let solunarStatus = Solunar.current(
                        date: start.midpoint(end),
                        coordinates: testLocation.waypoint.coordinate
                    )
                    #expect (solunarStatus.magicHour == .goldenHour)
                }
            }
        }
        
        @Test
        func blueHourDawn() throws {
            for testLocation in testSolarData {
                if let start = testLocation.solarData.morningBlueHourStart, let end = testLocation.solarData.morningBlueHourEnd {
                    let solunarStatus = Solunar.current(
                        date: start.midpoint(end),
                        coordinates: testLocation.waypoint.coordinate
                    )
                    #expect (solunarStatus.magicHour == .blueHour)
                }
            }
        }
        
        @Test
        func blueHourDusk() throws {
            for testLocation in testSolarData {
                if let start = testLocation.solarData.eveningBlueHourStart, let end = testLocation.solarData.eveningBlueHourEnd {
                    let solunarStatus = Solunar.current(
                        date: start.midpoint(end),
                        coordinates: testLocation.waypoint.coordinate
                    )
                    #expect (solunarStatus.magicHour == .blueHour)
                }
            }
        }

        @Test
        func nighttime() throws {
            for testLocation in testSolarData {
                if let date = testLocation.solarData.astronomicalDawn {
                    let solunarStatus = Solunar.current(
                        date: date,
                        coordinates: testLocation.waypoint.coordinate
                    )
                    #expect (solunarStatus.magicHour == nil)
                }
            }
        }

        @Test
        func daytime() throws {
            for testLocation in testSolarData {
                if let date = testLocation.solarData.solarNoon {
                    let solunarStatus = Solunar.current(
                        date: date,
                        coordinates: testLocation.waypoint.coordinate
                    )
                    #expect (solunarStatus.magicHour == nil)
                }
            }
        }
    }
    
    struct SolarStateTests {
        var testSolarData: [TestSolarData] = []
        
        internal init() {
            testSolarData = TestSolarData.load()
        }
        
        func solarState(_ start: Date?, _ end: Date?, _ coordinates: CLLocationCoordinate2D) -> SolarState? {
            guard let start, let end else { return nil }
            let solunarStatus = Solunar.current(
                date: start.midpoint(end),
                coordinates: coordinates
            )
            return solunarStatus.solarState
        }
        
        @Test
        func night() throws {
            for testLocation in testSolarData {
                if let date = testLocation.solarData.astronomicalDawn {
                    let solunarStatus = Solunar.current(
                        date: date.add(minutes: -5),
                        coordinates: testLocation.waypoint.coordinate
                    )
                    #expect (solunarStatus.solarState == .night)
                }
            }
        }
        
        @Test
        func astronomicalTwilightDawn() throws {
            for testLocation in testSolarData {
                let start = testLocation.solarData.astronomicalDawn
                let end = testLocation.solarData.nauticalDawn
                let coordinates = testLocation.waypoint.coordinate
                
                #expect (solarState(start, end, coordinates) == .astronomicalTwilight)
            }
        }

        @Test
        func astronomicalTwilightDusk() throws {
            for testLocation in testSolarData {
                let start = testLocation.solarData.nauticalDusk
                let end = testLocation.solarData.astronomicalDusk
                let coordinates = testLocation.waypoint.coordinate
                
                #expect (solarState(start, end, coordinates) == .astronomicalTwilight)
            }
        }

        @Test
        func nauticalTwilightDawn() throws {
            for testLocation in testSolarData {
                let start = testLocation.solarData.nauticalDawn
                let end = testLocation.solarData.civilDawn
                let coordinates = testLocation.waypoint.coordinate

                #expect (solarState(start, end, coordinates) == .nauticalTwilight)
            }
        }
        

        @Test
        func nauticalTwilightDusk() throws {
            for testLocation in testSolarData {
                let start = testLocation.solarData.civilDusk
                let end = testLocation.solarData.nauticalDusk
                let coordinates = testLocation.waypoint.coordinate

                #expect (solarState(start, end, coordinates) == .nauticalTwilight)
            }
        }
        
        @Test
        func civilTwilightDawn() throws {
            for testLocation in testSolarData {
                let start = testLocation.solarData.civilDawn
                let end = testLocation.solarData.sunrise
                let coordinates = testLocation.waypoint.coordinate

                #expect (solarState(start, end, coordinates) == .civilTwilight)
            }
        }
        
        @Test
        func civilTwilightDusk() throws {
            for testLocation in testSolarData {
                let start = testLocation.solarData.sunset
                let end = testLocation.solarData.civilDusk
                let coordinates = testLocation.waypoint.coordinate

                #expect (solarState(start, end, coordinates) == .civilTwilight)
            }
        }
        
        @Test
        func daylight() throws {
            for testLocation in testSolarData {
                if let date = testLocation.solarData.sunrise {
                    let solunarStatus = Solunar.current(
                        date: date.add(minutes: 5),
                        coordinates: testLocation.waypoint.coordinate
                    )
                    #expect (solunarStatus.solarState == .daylight)
                }
            }
        }
    }
    
    struct MoonState {
        let lunarTestData: [TestLunarData]
        
        internal init() {
            lunarTestData = TestLunarData.load()
        }
        
        @Test
        func risen() throws {
            for testLocation in lunarTestData {
                if let date = testLocation.lunarData.rise {
                    let solunarStatus = Solunar.current(
                        date: date.add(minutes: 5),
                        coordinates: testLocation.waypoint.coordinate
                    )
                    #expect (solunarStatus.moonState == .risen)
                }
            }
        }
        
        @Test
        func set() throws {
            for testLocation in lunarTestData {
                if let date = testLocation.lunarData.set {
                    let solunarStatus = Solunar.current(
                        date: date.add(minutes: 5),
                        coordinates: testLocation.waypoint.coordinate
                    )
                    #expect (solunarStatus.moonState == .set)
                }
            }
        }
    }
    
    struct MoonIllumination {
        let lunarTestData: [TestLunarData]
        
        internal init() {
            lunarTestData = TestLunarData.load()
        }
        
        @Test
        func illumination() {
            for testLocation in lunarTestData {
                if let date = testLocation.lunarData.rise {
                    let solunarStatus = Solunar.current(
                        date: date,
                        coordinates: testLocation.waypoint.coordinate
                    )
                    #expect((testLocation.lunarData.illumination * 100).rounded() == (solunarStatus.moonIllumination * 100).rounded())
                }
            }
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

extension Date {
    public func midpoint(_ other: Date) -> Date {
        return Date(timeIntervalSince1970: (self.timeIntervalSince1970 + other.timeIntervalSince1970) / 2)
    }
}
