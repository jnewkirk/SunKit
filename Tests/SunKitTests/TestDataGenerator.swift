import CoreLocation
import SwiftAA
import Testing
@testable import SunKit

@Suite(.disabled())
struct TestDataGenerator {
    @Test
    func generateSolunarData() {
        let waypoints = Waypoint.load()
        var newData: [TestSolunarData] = []
        let date = "2025-03-28T00:48:00Z".toDate()!

        for waypoint in waypoints {
            let startDate = date.midnightLocal(timeZone: waypoint.timeZone)
            let endDate = startDate.add(days: 1)
            let solunarEvents = Solunar.getEvents(interval: DateInterval(start: startDate, end: endDate), coordinates: waypoint.coordinate, events: SolunarEventKind.allCases)

            newData.append(solunarEvents.testSolunarData(date, waypoint))
        }

        TestSolunarData.save(newData)
    }
}

extension Array where Element == SolunarEvent {
    func testSolunarData(_ date: Date, _ waypoint: Waypoint) -> TestSolunarData {
        return TestSolunarData(waypoint: waypoint, date: date, events: self)
    }
}
