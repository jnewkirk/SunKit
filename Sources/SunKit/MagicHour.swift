public enum MagicHour: Sendable, CaseIterable {
    case goldenHour
    case blueHour
    
    public static func from(altitude: Double) -> MagicHour? {
        switch altitude {
        case -6.0..<(-4.0):
            return .blueHour
        case -4.0..<(6.0):
            return .goldenHour
        default:
            return nil
        }
    }
}
