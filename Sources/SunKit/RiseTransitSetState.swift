import Foundation

public enum RiseTransitSetState: Sendable {
    case rise
    case transit
    case set

    func value(of: RiseTransitSet) -> Date? {
        switch self {
        case .rise:
            return of.rise
        case .transit:
            return nil
        case .set:
            return of.set
        }
    }
}
