import CoreLocation
import SwiftAA
import Testing
@testable import SunKit

@Suite(.disabled())
struct TestDataGenerator {
    @Test
    func generateSolunarData() {
        let locationDescriptors = LocationDescriptor.load()
        var newData: [TestSolunarData] = []
        let date = "2025-03-28T00:48:00Z".toDate()!

        for locationDescriptor in locationDescriptors {
            let startDate = date.midnightLocal(timeZone: locationDescriptor.timeZone)
            let endDate = startDate.add(days: 1)
            let solunarEvents = Solunar.getEvents(interval: DateInterval(start: startDate, end: endDate), coordinates: locationDescriptor.coordinate, events: SolunarEventKind.allCases)

            newData.append(solunarEvents.testSolunarData(date, locationDescriptor))
        }

        TestSolunarData.save(newData)
    }
}

extension Array where Element == SolunarEvent {
    func testSolunarData(_ date: Date, _ locationDescriptor: LocationDescriptor) -> TestSolunarData {
        return TestSolunarData(locationDescriptor: locationDescriptor, date: date, events: self)
    }
}
