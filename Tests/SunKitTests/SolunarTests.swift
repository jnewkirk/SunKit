import Foundation
import CoreLocation
import Testing
@testable import SunKit

struct SolunarTests {
    struct MagicHour {
        var testData: [TestSolunarData] = []

        internal init() {
            testData = TestSolunarData.load()
        }

        @Test
        func goldenHourDawn() throws {
            for testLocation in testData {
                if let start = testLocation.events.first(.goldenHourDawnStart), let end = testLocation.events.first(.goldenHourDawnEnd) {
                    let solunarStatus = Solunar.current(
                        date: start.date.midpoint(end.date),
                        coordinates: testLocation.locationDescriptor.coordinate
                    )
                    #expect (solunarStatus.magicHour == .goldenHour)
                } else {
                    Issue.record("\(testLocation.locationDescriptor.name)")
                }
            }
        }

        @Test
        func goldenHourDusk() throws {
            for testLocation in testData {
                if let start = testLocation.events.first(.goldenHourDuskStart), let end = testLocation.events.first(.goldenHourDuskEnd) {
                    let solunarStatus = Solunar.current(
                        date: start.date.midpoint(end.date),
                        coordinates: testLocation.locationDescriptor.coordinate
                    )
                    #expect (solunarStatus.magicHour == .goldenHour)
                } else {
                    Issue.record("\(testLocation.locationDescriptor.name)")
                }
            }
        }

        @Test
        func blueHourDawn() throws {
            for testLocation in testData {
                if let start = testLocation.events.first(.blueHourDawnStart), let end = testLocation.events.first(.blueHourDawnEnd) {
                    let solunarStatus = Solunar.current(
                        date: start.date.midpoint(end.date),
                        coordinates: testLocation.locationDescriptor.coordinate
                    )
                    #expect (solunarStatus.magicHour == .blueHour)
                } else {
                    Issue.record("\(testLocation.locationDescriptor.name)")
                }
            }
        }

        @Test
        func blueHourDusk() throws {
            for testLocation in testData {
                if let start = testLocation.events.first(.blueHourDuskStart), let end = testLocation.events.first(.blueHourDuskEnd) {
                    let solunarStatus = Solunar.current(
                        date: start.date.midpoint(end.date),
                        coordinates: testLocation.locationDescriptor.coordinate
                    )
                    #expect (solunarStatus.magicHour == .blueHour)
                } else {
                    Issue.record("\(testLocation.locationDescriptor.name)")
                }
            }
        }

        @Test
        func nighttime() throws {
            for testLocation in testData {
                if let start = testLocation.events.first(.astronomicalDawnStart) {
                    let solunarStatus = Solunar.current(
                        date: start.date,
                        coordinates: testLocation.locationDescriptor.coordinate
                    )
                    #expect (solunarStatus.magicHour == nil)
                } else {
                    Issue.record("\(testLocation.locationDescriptor.name)")
                }
            }
        }

        @Test
        func daytime() throws {
            for testLocation in testData {
                if let start = testLocation.events.first(.solarNoon) {
                    let solunarStatus = Solunar.current(
                        date: start.date,
                        coordinates: testLocation.locationDescriptor.coordinate
                    )
                    #expect (solunarStatus.magicHour == nil)
                } else {
                    Issue.record("\(testLocation.locationDescriptor.name)")
                }
            }
        }
    }

    struct SolarStateTests {
        var testData: [TestSolunarData] = []

        internal init() {
            testData = TestSolunarData.load()
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
            for testLocation in testData {
                if let start = testLocation.events.first(.astronomicalDawnStart) {
                    let solunarStatus = Solunar.current(
                        date: start.date.add(minutes: -5),
                        coordinates: testLocation.locationDescriptor.coordinate
                    )
                    #expect (solunarStatus.solarState == .night)
                } else {
                    Issue.record("\(testLocation.locationDescriptor.name)")
                }
            }
        }

        @Test
        func astronomicalTwilightDawn() throws {
            for testLocation in testData {
                if let start = testLocation.events.first(.astronomicalDawnStart), let end = testLocation.events.first(.astronomicalDawnEnd) {
                    let coordinates = testLocation.locationDescriptor.coordinate

                    #expect (solarState(start.date, end.date, coordinates) == .astronomicalTwilight)
                } else {
                    Issue.record("\(testLocation.locationDescriptor.name)")
                }
            }
        }

        @Test
        func astronomicalTwilightDusk() throws {
            for testLocation in testData {
                if let start = testLocation.events.first(.astronomicalDuskStart), let end = testLocation.events.first(.astronomicalDuskEnd) {
                    let coordinates = testLocation.locationDescriptor.coordinate

                    #expect (solarState(start.date, end.date, coordinates) == .astronomicalTwilight)
                } else {
                    Issue.record("\(testLocation.locationDescriptor.name)")
                }
            }
        }

        @Test
        func nauticalTwilightDawn() throws {
            for testLocation in testData {
                if let start = testLocation.events.first(.nauticalDawnStart), let end = testLocation.events.first(.nauticalDawnEnd) {
                    let coordinates = testLocation.locationDescriptor.coordinate

                    #expect (solarState(start.date, end.date, coordinates) == .nauticalTwilight)
                } else {
                    Issue.record("\(testLocation.locationDescriptor.name)")
                }
            }
        }

        @Test
        func nauticalTwilightDusk() throws {
            for testLocation in testData {
                if let start = testLocation.events.first(.nauticalDuskStart), let end = testLocation.events.first(.nauticalDuskEnd) {
                    let coordinates = testLocation.locationDescriptor.coordinate

                    #expect (solarState(start.date, end.date, coordinates) == .nauticalTwilight)
                } else {
                    Issue.record("\(testLocation.locationDescriptor.name)")
                }
            }
        }

        @Test
        func civilTwilightDawn() throws {
            for testLocation in testData {
                if let start = testLocation.events.first(.civilDawnStart), let end = testLocation.events.first(.civilDawnEnd) {
                    let coordinates = testLocation.locationDescriptor.coordinate

                    #expect (solarState(start.date, end.date, coordinates) == .civilTwilight)
                } else {
                    Issue.record("\(testLocation.locationDescriptor.name)")
                }
            }
        }

        @Test
        func civilTwilightDusk() throws {
            for testLocation in testData {
                if let start = testLocation.events.first(.civilDuskStart), let end = testLocation.events.first(.civilDuskEnd) {
                    let coordinates = testLocation.locationDescriptor.coordinate

                    #expect (solarState(start.date, end.date, coordinates) == .civilTwilight)
                } else {
                    Issue.record("\(testLocation.locationDescriptor.name)")
                }
            }
        }

        @Test
        func daylight() throws {
            for testLocation in testData {
                if let start = testLocation.events.first(.sunrise) {
                    let solunarStatus = Solunar.current(
                        date: start.date.add(minutes: 5),
                        coordinates: testLocation.locationDescriptor.coordinate
                    )
                    #expect (solunarStatus.solarState == .daylight)
                }
            }
        }
    }

    struct MoonStateTests {
        let testData: [TestSolunarData]

        internal init() {
            testData = TestSolunarData.load()
        }

        @Test
        func moonrise() throws {
            for testLocation in testData {
                if let moonrise = testLocation.events.first(.moonrise) {
                    let solunarStatus = Solunar.current(
                        date: moonrise.date.add(minutes: 5),
                        coordinates: testLocation.locationDescriptor.coordinate
                    )
                    #expect (solunarStatus.moonState == .risen)
                }
            }
        }

        @Test
        func moonset() throws {
            for testLocation in testData {
                if let moonset = testLocation.events.first(.moonset) {
                    let solunarStatus = Solunar.current(
                        date: moonset.date.add(minutes: 5),
                        coordinates: testLocation.locationDescriptor.coordinate
                    )
                    #expect (solunarStatus.moonState == .set)
                }
            }
        }
    }

    struct GalacticCenterStateTests {
        let testData: [TestSolunarData]

        internal init() {
            testData = TestSolunarData.load()
        }

        @Test
        func galacticCenterRise() throws {
            for testLocation in testData {
                if let rise = testLocation.events.first(.galacticCenterRise) {
                    let solunarStatus = Solunar.current(
                        date: rise.date.add(minutes: 5),
                        coordinates: testLocation.locationDescriptor.coordinate
                    )
                    #expect (solunarStatus.galacticCenterState == .risen)
                }
            }
        }

        @Test
        func galacticCenterSet() throws {
            for testLocation in testData {
                if let set = testLocation.events.first(.galacticCenterSet) {
                    let solunarStatus = Solunar.current(
                        date: set.date.add(minutes: 5),
                        coordinates: testLocation.locationDescriptor.coordinate
                    )
                    #expect (solunarStatus.galacticCenterState == .set)
                }
            }
        }
    }

    struct MoonPhase {
        @Test
        func full() {
            let solunarStatus = Solunar.current(
                date: "2026-04-02T00:11:00Z".toDate()!,
                coordinates: Constant.puyallup
            )
            #expect(.full == solunarStatus.moonPhase)
            #expect(100 == (solunarStatus.moonIllumination * 100.0).rounded())
        }

        @Test
        func new() {
            let solunarStatus = Solunar.current(
                date: "2026-03-19T01:23:00Z".toDate()!,
                coordinates: Constant.puyallup
            )
            #expect(.new == solunarStatus.moonPhase)
            #expect(0 == (solunarStatus.moonIllumination * 100.0).rounded())
        }

        @Test
        func firstQuarter() {
            let solunarStatus = Solunar.current(
                date: "2026-03-25T19:17:00Z".toDate()!,
                coordinates: Constant.puyallup
            )
            #expect(.firstQuarter == solunarStatus.moonPhase)
            #expect(50 == (solunarStatus.moonIllumination * 100.0).rounded())
        }

        @Test
        func thirdQuarter() {
            let solunarStatus = Solunar.current(
                date: "2026-03-11T09:38:00Z".toDate()!,
                coordinates: Constant.puyallup
            )
            #expect(.thirdQuarter == solunarStatus.moonPhase)
            #expect(50 == (solunarStatus.moonIllumination * 100.0).rounded())
        }

        @Test
        func waxingGibbous() {
            let solunarStatus = Solunar.current(
                date: "2026-02-27T21:10:00Z".toDate()!,
                coordinates: Constant.puyallup
            )
            #expect(.waxingGibbous == solunarStatus.moonPhase)
            #expect(85 == (solunarStatus.moonIllumination * 100.0).rounded())
        }

        @Test
        func waningGibbous() {
            let solunarStatus = Solunar.current(
                date: "2026-03-04T21:10:00Z".toDate()!,
                coordinates: Constant.puyallup
            )
            #expect(.waningGibbous == solunarStatus.moonPhase)
            #expect(98 == (solunarStatus.moonIllumination * 100.0).rounded())
        }

        @Test
        func waningCrescent() {
            let solunarStatus = Solunar.current(
                date: "2026-03-12T21:10:00Z".toDate()!,
                coordinates: Constant.puyallup
            )
            #expect(.waningCrescent == solunarStatus.moonPhase)
            #expect(36 == (solunarStatus.moonIllumination * 100.0).rounded())
        }

        @Test
        func waxingCrescent() {
            let solunarStatus = Solunar.current(
                date: "2026-03-20T21:10:00Z".toDate()!,
                coordinates: Constant.puyallup
            )
            #expect(.waxingCrescent == solunarStatus.moonPhase)
            #expect(4 == (solunarStatus.moonIllumination * 100.0).rounded())
        }
    }

    struct GetEvents {
        @Test
        func sunrises() throws {
            let interval = DateInterval(
                start: "2026-03-10T07:00:00Z".toDate()!,
                end: "2026-03-13T07:00:00Z".toDate()!
            )
            let events = Solunar.getEvents(
                interval: interval,
                coordinates: Constant.puyallup,
                events: [.sunrise]
            )

            try #require(events.count == 3)
            #expect(events[0].kind == .sunrise)
            #expect(events[0].date == "2026-03-10T14:30:00Z".toDate())
            #expect(events[1].kind == .sunrise)
            #expect(events[1].date == "2026-03-11T14:28:00Z".toDate())
            #expect(events[2].kind == .sunrise)
            #expect(events[2].date == "2026-03-12T14:26:00Z".toDate())
        }

        @Test
        func sunsets() throws {
            let interval = DateInterval(
                start: "2026-03-10T07:00:00Z".toDate()!,
                end: "2026-03-13T07:00:00Z".toDate()!
            )
            let events = Solunar.getEvents(
                interval: interval,
                coordinates: Constant.puyallup,
                events: [.sunset]
            )

            try #require(events.count == 3)
            #expect(events[0].kind == .sunset)
            #expect(events[0].date == "2026-03-11T02:07:00Z".toDate())
            #expect(events[1].kind == .sunset)
            #expect(events[1].date == "2026-03-12T02:08:00Z".toDate())
            #expect(events[2].kind == .sunset)
            #expect(events[2].date == "2026-03-13T02:09:00Z".toDate())
        }

        @Test
        func sunrisesAndSunset() throws {
            let interval = DateInterval(
                start: "2026-03-10T07:00:00Z".toDate()!,
                end: "2026-03-13T07:00:00Z".toDate()!
            )
            let events = Solunar.getEvents(
                interval: interval,
                coordinates: Constant.puyallup,
                events: [.sunrise, .sunset]
            )

            try #require(events.count == 6)
            #expect(events[0].kind == .sunrise)
            #expect(events[0].date == "2026-03-10T14:30:00Z".toDate())
            #expect(events[0].azimuthAngleInDegrees.rounded() == 95)

            #expect(events[1].kind == .sunset)
            #expect(events[1].date == "2026-03-11T02:07:00Z".toDate())
            #expect(events[1].azimuthAngleInDegrees.rounded() == 265)

            #expect(events[2].kind == .sunrise)
            #expect(events[2].date == "2026-03-11T14:28:00Z".toDate())
            #expect(events[2].azimuthAngleInDegrees.rounded() == 94)

            #expect(events[3].kind == .sunset)
            #expect(events[3].date == "2026-03-12T02:08:00Z".toDate())
            #expect(events[3].azimuthAngleInDegrees.rounded() == 266)

            #expect(events[4].kind == .sunrise)
            #expect(events[4].date == "2026-03-12T14:26:00Z".toDate())
            #expect(events[4].azimuthAngleInDegrees.rounded() == 93)

            #expect(events[5].kind == .sunset)
            #expect(events[5].date == "2026-03-13T02:09:00Z".toDate())
            #expect(events[5].azimuthAngleInDegrees.rounded() == 266)
        }

        @Test
        func oneDay() throws {
            let date = try #require("2026-03-11T07:00:00Z".toDate())
            let interval = DateInterval(start: date, duration: 24 * 60 * 60)
            let coordinates = Constant.puyallup

            let solunarEvents = Solunar.getEvents(interval: interval, coordinates: coordinates, events: SolunarEventKind.allCases)

            try #require(solunarEvents.count == 29)

            verifySolunarEvent(solunarEvents[0], "2026-03-11T10:34:00Z", SolunarEventKind.moonrise)
            verifySolunarEvent(solunarEvents[1], "2026-03-11T10:59:00Z", SolunarEventKind.galacticCenterRise)
            verifySolunarEvent(solunarEvents[2], "2026-03-11T12:47:00Z", SolunarEventKind.astronomicalDawnStart)
            verifySolunarEvent(solunarEvents[3], "2026-03-11T13:23:00Z", SolunarEventKind.astronomicalDawnEnd)
            verifySolunarEvent(solunarEvents[4], "2026-03-11T13:23:00Z", SolunarEventKind.nauticalDawnStart)
            verifySolunarEvent(solunarEvents[5], "2026-03-11T13:58:00Z", SolunarEventKind.nauticalDawnEnd)
            verifySolunarEvent(solunarEvents[6], "2026-03-11T13:58:00Z", SolunarEventKind.civilDawnStart)
            verifySolunarEvent(solunarEvents[7], "2026-03-11T13:58:00Z", SolunarEventKind.blueHourDawnStart)
            verifySolunarEvent(solunarEvents[8], "2026-03-11T14:10:00Z", SolunarEventKind.blueHourDawnEnd)
            verifySolunarEvent(solunarEvents[9], "2026-03-11T14:10:00Z", SolunarEventKind.goldenHourDawnStart)
            verifySolunarEvent(solunarEvents[10], "2026-03-11T14:20:00Z", SolunarEventKind.moonApex)
            verifySolunarEvent(solunarEvents[11], "2026-03-11T14:28:00Z", SolunarEventKind.civilDawnEnd)
            verifySolunarEvent(solunarEvents[12], "2026-03-11T14:28:00Z", SolunarEventKind.sunrise)
            verifySolunarEvent(solunarEvents[13], "2026-03-11T14:36:00Z", SolunarEventKind.galacticCenterApex)
            verifySolunarEvent(solunarEvents[14], "2026-03-11T15:09:00Z", SolunarEventKind.goldenHourDawnEnd)
            verifySolunarEvent(solunarEvents[15], "2026-03-11T18:04:00Z", SolunarEventKind.moonset)
            verifySolunarEvent(solunarEvents[16], "2026-03-11T18:14:00Z", SolunarEventKind.galacticCenterSet)
            verifySolunarEvent(solunarEvents[17], "2026-03-11T20:18:00Z", SolunarEventKind.solarNoon)
            verifySolunarEvent(solunarEvents[18], "2026-03-12T01:27:00Z", SolunarEventKind.goldenHourDuskStart)
            verifySolunarEvent(solunarEvents[19], "2026-03-12T02:08:00Z", SolunarEventKind.sunset)
            verifySolunarEvent(solunarEvents[20], "2026-03-12T02:08:00Z", SolunarEventKind.civilDuskStart)
            verifySolunarEvent(solunarEvents[21], "2026-03-12T02:27:00Z", SolunarEventKind.goldenHourDuskEnd)
            verifySolunarEvent(solunarEvents[22], "2026-03-12T02:27:00Z", SolunarEventKind.blueHourDuskStart)
            verifySolunarEvent(solunarEvents[23], "2026-03-12T02:38:00Z", SolunarEventKind.blueHourDuskEnd)
            verifySolunarEvent(solunarEvents[24], "2026-03-12T02:38:00Z", SolunarEventKind.civilDuskEnd)
            verifySolunarEvent(solunarEvents[25], "2026-03-12T02:38:00Z", SolunarEventKind.nauticalDuskStart)
            verifySolunarEvent(solunarEvents[26], "2026-03-12T03:14:00Z", SolunarEventKind.nauticalDuskEnd)
            verifySolunarEvent(solunarEvents[27], "2026-03-12T03:14:00Z", SolunarEventKind.astronomicalDuskStart)
            verifySolunarEvent(solunarEvents[28], "2026-03-12T03:50:00Z", SolunarEventKind.astronomicalDuskEnd)
        }

        func verifySolunarEvent(_ event: SolunarEvent, _ date: String, _ kind: SolunarEventKind) {
            #expect(date.toDate() == event.date)
            #expect(kind == event.kind)
        }

        @Test
        func noSunrise() {
            let start = "2025-12-14T04:00:00Z".toDate()!
            let end = start.add(days: 1)
            let events = Solunar.getEvents(interval: DateInterval(start: start, end: end), coordinates: Constant.longyearbyen, events: [.sunrise])

            #expect(events.isEmpty)
        }

        @Test
        func noSunset() throws {
            let start = "2025-04-19T04:00:00Z".toDate()!
            let end = start.add(days: 1)
            let events = Solunar.getEvents(interval: DateInterval(start: start, end: end), coordinates: Constant.longyearbyen, events: [.sunset])

            #expect(events.isEmpty)
        }
    }
}

extension Date {
    public func midpoint(_ other: Date) -> Date {
        return Date(timeIntervalSince1970: (self.timeIntervalSince1970 + other.timeIntervalSince1970) / 2)
    }
}

extension Array where Element == SolunarEvent {
    func first(_ kind: SolunarEventKind) -> SolunarEvent? {
        first { $0.kind == kind }
    }
}
