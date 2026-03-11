//import Foundation
//import CoreLocation
//import Testing
//@testable import SunKit
//
//struct SolunarEventTests {
////    @Test(.disabled("Galactic center visibility is not correct yet"))
////    func lunarOneDay() throws {
////        let formatter = ISO8601DateFormatter()
////        let date = try #require(formatter.date(from: "2026-02-12T08:00:00Z"))
////        let interval = DateInterval(start: date, duration: 24 * 60 * 60)
////        let coordinates = Constant.puyallup
////        
////        let solunarEvents = SolunarEvent.makeRange(interval: interval, at: coordinates, events: SolunarEventKind.lunarEvents)
////        
////        try #require(solunarEvents.count == 4)
////        
////        #expect(formatter.date(from: "2026-02-12T12:45:00Z") == solunarEvents[0].date)
////        #expect(SolunarEventKind.galacticCenterVisibilityStart == solunarEvents[0].kind)
////        
////        #expect(formatter.date(from: "2026-02-12T12:45:00Z") == solunarEvents[1].date)
////        #expect(SolunarEventKind.moonrise == solunarEvents[1].kind)
////        
////        #expect(formatter.date(from: "2026-02-12T13:36:00Z") == solunarEvents[2].date)
////        #expect(SolunarEventKind.galacticCenterVisibilityEnd == solunarEvents[2].kind)
////        
////        #expect(formatter.date(from: "2026-02-12T20:15:00Z") == solunarEvents[3].date)
////        #expect(SolunarEventKind.moonset == solunarEvents[3].kind)
////    }
////    
//    @Test
//    func sunriseSunsetThreeDays() throws {
//        let formatter = ISO8601DateFormatter()
//        let date = try #require(formatter.date(from: "2025-01-22T19:00:00Z"))
//        let interval = DateInterval(start: date, duration: 3 * 24 * 60 * 60)
//        let coordinates = Constant.alienThrone
//        
//        let solunarEvents = SolunarEvent.makeRange(interval: interval, at: coordinates, events: [.sunrise, .sunset])
//        
//        try #require(solunarEvents.count == 6)
//        
//        #expect(formatter.date(from: "2025-01-23T00:27:00Z") == solunarEvents[0].date)
//        #expect(SolunarEventKind.sunset == solunarEvents[0].kind)
//        
//        #expect(formatter.date(from: "2025-01-23T14:17:00Z") == solunarEvents[1].date)
//        #expect(SolunarEventKind.sunrise == solunarEvents[1].kind)
//        
//        #expect(formatter.date(from: "2025-01-24T00:28:00Z") == solunarEvents[2].date)
//        #expect(SolunarEventKind.sunset == solunarEvents[2].kind)
//        
//        #expect(formatter.date(from: "2025-01-24T14:17:00Z") == solunarEvents[3].date)
//        #expect(SolunarEventKind.sunrise == solunarEvents[3].kind)
//        
//        #expect(formatter.date(from: "2025-01-25T00:29:00Z") == solunarEvents[4].date)
//        #expect(SolunarEventKind.sunset == solunarEvents[4].kind)
//        
//        #expect(formatter.date(from: "2025-01-25T14:16:00Z") == solunarEvents[5].date)
//        #expect(SolunarEventKind.sunrise == solunarEvents[5].kind)
//    }
//    
////    @Test
////    func moonriseMoonsetThreeDays() throws {
////        let formatter = ISO8601DateFormatter()
////        let date = try #require(formatter.date(from: "2025-01-22T06:00:00Z"))
////        let interval = DateInterval(start: date, duration: 3 * 24 * 60 * 60)
////        let coordinates = Constant.alienThrone
////        
////        let solunarEvents = SolunarEvent.makeRange(interval: interval, at: coordinates, events: [.moonrise, .moonset])
////        
////        try #require(solunarEvents.count == 6)
////        
////        #expect(formatter.date(from: "2025-01-22T08:13:00Z") == solunarEvents[0].date)
////        #expect(SolunarEventKind.moonrise == solunarEvents[0].kind)
////        
////        #expect(formatter.date(from: "2025-01-22T18:40:00Z") == solunarEvents[1].date)
////        #expect(SolunarEventKind.moonset == solunarEvents[1].kind)
////        
////        #expect(formatter.date(from: "2025-01-23T09:14:00Z") == solunarEvents[2].date)
////        #expect(SolunarEventKind.moonrise == solunarEvents[2].kind)
////        
////        #expect(formatter.date(from: "2025-01-23T19:11:00Z") == solunarEvents[3].date)
////        #expect(SolunarEventKind.moonset == solunarEvents[3].kind)
////        
////        #expect(formatter.date(from: "2025-01-24T10:16:00Z") == solunarEvents[4].date)
////        #expect(SolunarEventKind.moonrise == solunarEvents[4].kind)
////        
////        #expect(formatter.date(from: "2025-01-24T19:49:00Z") == solunarEvents[5].date)
////        #expect(SolunarEventKind.moonset == solunarEvents[5].kind)
////    }
//}
