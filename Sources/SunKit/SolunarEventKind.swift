public enum SolunarEventKind: Sendable, CaseIterable {
    case sunrise, sunset, civilDawn, civilDusk, astronomicalDawn, astronomicalDusk, nauticalDawn, nauticalDusk, blueHourDawnEnd, blueHourDuskStart, goldenHourDawnEnd, goldenHourDuskStart

    var solarEvent: SolarEvent {
        switch self {
        case .sunrise:
            return SolarEvent.sunrise
        case .sunset:
            return SolarEvent.sunset
        case .civilDawn:
            return SolarEvent.civilDawn
        case .civilDusk:
            return SolarEvent.civilDusk
        case .astronomicalDawn:
            return SolarEvent.astronomicalDawn
        case .astronomicalDusk:
            return SolarEvent.astronomicalDusk
        case .nauticalDawn:
            return SolarEvent.nauticalDawn
        case .nauticalDusk:
            return SolarEvent.nauticalDusk
        case .blueHourDawnEnd:
            return SolarEvent.blueHourEndDawn
        case .blueHourDuskStart:
            return SolarEvent.blueHourStartDusk
        case .goldenHourDawnEnd:
            return SolarEvent.goldenHourEndDawn
        case .goldenHourDuskStart:
            return SolarEvent.goldenHourStartDusk
        }
    }
}
