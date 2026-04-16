import Foundation

struct Constant {
    static var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = Constant.utcTimezone

        return calendar
    }

    public static let utcTimezone = TimeZone(identifier: "UTC")!
}
