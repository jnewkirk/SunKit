import Foundation

extension String {
    public func toDate() -> Date? {
        let formatter = ISO8601DateFormatter()
        
        return formatter.date(from: self)
    }
}
