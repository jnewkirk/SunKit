public enum SolarState: Sendable, CaseIterable {
    case night
    case astronomicalTwilight
    case nauticalTwilight
    case civilTwilight
    case blueHourDawn
    case blueHourDusk
    case goldenHourDawn
    case goldenHourDusk
    case daylight
    
    /// Determines the sun's position based on its altitude angle in degrees and whether the sun is rising
    public static func from(altitude: Double) -> SolarState {
        switch altitude {
        case ..<(-18.0):
            return .night
        case -18.0..<(-12.0):
            return .astronomicalTwilight
        case -12.0..<(-6.0):
            return .nauticalTwilight
        case -6.0..<(-0.833):
            return .civilTwilight
        default:
            return .daylight
        }
    }
}
