import Foundation
import CoreLocation
import Testing
@testable import SunKit

struct SolunarEventTests {
    @Test
    func solarOneDay() throws {
        let formatter = ISO8601DateFormatter()
        let date = try #require(formatter.date(from: "2025-01-22T06:00:00Z"))
        let interval = DateInterval(start: date, duration: 24 * 60 * 60)
        let coordinates = Constant.alienThrone
        
        let solunarEvents = SolunarEvent.makeRange(interval: interval, at: coordinates, events: SolunarEventKind.solarEvents)
        
        try #require(solunarEvents.count == 12)
        
        #expect(formatter.date(from: "2025-01-22T12:49:00Z") == solunarEvents[0].date)
        #expect(SolunarEventKind.astronomicalDawn == solunarEvents[0].kind)
        
        #expect(formatter.date(from: "2025-01-22T13:19:00Z") == solunarEvents[1].date)
        #expect(SolunarEventKind.nauticalDawn == solunarEvents[1].kind)
        
        #expect(formatter.date(from: "2025-01-22T13:50:00Z") == solunarEvents[2].date)
        #expect(SolunarEventKind.civilDawn == solunarEvents[2].kind)
        
        #expect(formatter.date(from: "2025-01-22T14:01:00Z") == solunarEvents[3].date)
        #expect(SolunarEventKind.blueHourDawnEnd == solunarEvents[3].kind)
        
        #expect(formatter.date(from: "2025-01-22T14:18:00Z") == solunarEvents[4].date)
        #expect(SolunarEventKind.sunrise == solunarEvents[4].kind)
        #expect(114 == solunarEvents[4].azimuth.value.rounded())
        
        #expect(formatter.date(from: "2025-01-22T14:56:00Z") == solunarEvents[5].date)
        #expect(SolunarEventKind.goldenHourDawnEnd == solunarEvents[5].kind)
        
        #expect(formatter.date(from: "2025-01-22T23:49:00Z") == solunarEvents[6].date)
        #expect(SolunarEventKind.goldenHourDuskStart == solunarEvents[6].kind)
        
        #expect(formatter.date(from: "2025-01-23T00:27:00Z") == solunarEvents[7].date)
        #expect(SolunarEventKind.sunset == solunarEvents[7].kind)
        #expect(246 == solunarEvents[7].azimuth.value.rounded())
        
        #expect(formatter.date(from: "2025-01-23T00:44:00Z") == solunarEvents[8].date)
        #expect(SolunarEventKind.blueHourDuskStart == solunarEvents[8].kind)
        
        #expect(formatter.date(from: "2025-01-23T00:55:00Z") == solunarEvents[9].date)
        #expect(SolunarEventKind.civilDusk == solunarEvents[9].kind)
        
        #expect(formatter.date(from: "2025-01-23T01:26:00Z") == solunarEvents[10].date)
        #expect(SolunarEventKind.nauticalDusk == solunarEvents[10].kind)
        
        #expect(formatter.date(from: "2025-01-23T01:57:00Z") == solunarEvents[11].date)
        #expect(SolunarEventKind.astronomicalDusk == solunarEvents[11].kind)
    }
    
    @Test(.disabled("Galactic center visibility is not correct yet"))
    func lunarOneDay() throws {
        let formatter = ISO8601DateFormatter()
        let date = try #require(formatter.date(from: "2026-02-12T08:00:00Z"))
        let interval = DateInterval(start: date, duration: 24 * 60 * 60)
        let coordinates = Constant.puyallup
        
        let solunarEvents = SolunarEvent.makeRange(interval: interval, at: coordinates, events: SolunarEventKind.lunarEvents)
        
        try #require(solunarEvents.count == 4)
        
        #expect(formatter.date(from: "2026-02-12T12:45:00Z") == solunarEvents[0].date)
        #expect(SolunarEventKind.galacticCenterVisibilityStart == solunarEvents[0].kind)
        
        #expect(formatter.date(from: "2026-02-12T12:45:00Z") == solunarEvents[1].date)
        #expect(SolunarEventKind.moonrise == solunarEvents[1].kind)
        
        #expect(formatter.date(from: "2026-02-12T13:36:00Z") == solunarEvents[2].date)
        #expect(SolunarEventKind.galacticCenterVisibilityEnd == solunarEvents[2].kind)
        
        #expect(formatter.date(from: "2026-02-12T20:15:00Z") == solunarEvents[3].date)
        #expect(SolunarEventKind.moonset == solunarEvents[3].kind)
    }
    
    @Test
    func sunriseSunsetThreeDays() throws {
        let formatter = ISO8601DateFormatter()
        let date = try #require(formatter.date(from: "2025-01-22T19:00:00Z"))
        let interval = DateInterval(start: date, duration: 3 * 24 * 60 * 60)
        let coordinates = Constant.alienThrone
        
        let solunarEvents = SolunarEvent.makeRange(interval: interval, at: coordinates, events: [.sunrise, .sunset])
        
        try #require(solunarEvents.count == 6)
        
        #expect(formatter.date(from: "2025-01-23T00:27:00Z") == solunarEvents[0].date)
        #expect(SolunarEventKind.sunset == solunarEvents[0].kind)
        
        #expect(formatter.date(from: "2025-01-23T14:17:00Z") == solunarEvents[1].date)
        #expect(SolunarEventKind.sunrise == solunarEvents[1].kind)
        
        #expect(formatter.date(from: "2025-01-24T00:28:00Z") == solunarEvents[2].date)
        #expect(SolunarEventKind.sunset == solunarEvents[2].kind)
        
        #expect(formatter.date(from: "2025-01-24T14:17:00Z") == solunarEvents[3].date)
        #expect(SolunarEventKind.sunrise == solunarEvents[3].kind)
        
        #expect(formatter.date(from: "2025-01-25T00:29:00Z") == solunarEvents[4].date)
        #expect(SolunarEventKind.sunset == solunarEvents[4].kind)
        
        #expect(formatter.date(from: "2025-01-25T14:16:00Z") == solunarEvents[5].date)
        #expect(SolunarEventKind.sunrise == solunarEvents[5].kind)
    }
    
    @Test
    func moonriseMoonsetThreeDays() throws {
        let formatter = ISO8601DateFormatter()
        let date = try #require(formatter.date(from: "2025-01-22T06:00:00Z"))
        let interval = DateInterval(start: date, duration: 3 * 24 * 60 * 60)
        let coordinates = Constant.alienThrone
        
        let solunarEvents = SolunarEvent.makeRange(interval: interval, at: coordinates, events: [.moonrise, .moonset])
        
        try #require(solunarEvents.count == 6)
        
        #expect(formatter.date(from: "2025-01-22T08:13:00Z") == solunarEvents[0].date)
        #expect(SolunarEventKind.moonrise == solunarEvents[0].kind)
        
        #expect(formatter.date(from: "2025-01-22T18:40:00Z") == solunarEvents[1].date)
        #expect(SolunarEventKind.moonset == solunarEvents[1].kind)
        
        #expect(formatter.date(from: "2025-01-23T09:14:00Z") == solunarEvents[2].date)
        #expect(SolunarEventKind.moonrise == solunarEvents[2].kind)
        
        #expect(formatter.date(from: "2025-01-23T19:11:00Z") == solunarEvents[3].date)
        #expect(SolunarEventKind.moonset == solunarEvents[3].kind)
        
        #expect(formatter.date(from: "2025-01-24T10:16:00Z") == solunarEvents[4].date)
        #expect(SolunarEventKind.moonrise == solunarEvents[4].kind)
        
        #expect(formatter.date(from: "2025-01-24T19:49:00Z") == solunarEvents[5].date)
        #expect(SolunarEventKind.moonset == solunarEvents[5].kind)
    }
}
