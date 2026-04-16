import Foundation
import SwiftAA

public enum SolunarEventKind: Int, Codable, Sendable, CaseIterable {
    case
    // Solar
    astronomicalDawnStart = 100,

    astronomicalDawnEnd = 200,
    nauticalDawnStart = 201,

    nauticalDawnEnd = 300,
    civilDawnStart = 301,
    blueHourDawnStart = 302,

    blueHourDawnEnd = 400,
    goldenHourDawnStart = 401,

    civilDawnEnd = 500,
    sunrise = 501,

    goldenHourDawnEnd = 600,

    solarNoon = 700,

    goldenHourDuskStart = 800,

    sunset = 900,
    civilDuskStart = 901,

    goldenHourDuskEnd = 1000,
    blueHourDuskStart = 1001,

    blueHourDuskEnd = 1100,
    civilDuskEnd = 1101,
    nauticalDuskStart = 1102,

    nauticalDuskEnd = 1200,
    astronomicalDuskStart = 1201,

    astronomicalDuskEnd = 1300,

    // Lunar
    moonrise = 2000,

    moonApex = 2100,

    moonset = 2200,

    galacticCenterRise = 2300,

    galacticCenterApex = 2400,

    galacticCenterSet = 2500
}

extension SolunarEventKind {
    func calculator() -> SolunarCalculator? {
        switch self {
        case .astronomicalDawnStart:
            return SolarCalculator.astronomicalDawn
        case .astronomicalDawnEnd, .nauticalDawnStart:
            return SolarCalculator.nauticalDawn
        case .nauticalDawnEnd, .civilDawnStart, .blueHourDawnStart:
            return SolarCalculator.civilDawn
        case .blueHourDawnEnd, .goldenHourDawnStart:
            return SolarCalculator.blueHourEndDawn
        case .civilDawnEnd, .sunrise:
            return SolarCalculator.sunrise
        case .goldenHourDawnEnd:
            return SolarCalculator.goldenHourEndDawn
        case .solarNoon:
            return SolarCalculator.solarNoon
        case .goldenHourDuskStart:
            return SolarCalculator.goldenHourStartDusk
        case .sunset, .civilDuskStart:
            return SolarCalculator.sunset
        case .goldenHourDuskEnd, .blueHourDuskStart:
            return SolarCalculator.blueHourStartDusk
        case .civilDuskEnd, .blueHourDuskEnd, .nauticalDuskStart:
            return SolarCalculator.civilDusk
        case .nauticalDuskEnd, .astronomicalDuskStart:
            return SolarCalculator.nauticalDusk
        case .astronomicalDuskEnd:
            return SolarCalculator.astronomicalDusk
        case .moonrise:
            return LunarCalculator.moonrise
        case .moonApex:
            return LunarCalculator.moonApex
        case .moonset:
            return LunarCalculator.moonset
        case .galacticCenterRise:
            return LunarCalculator.galacticCenterRise
        case .galacticCenterApex:
            return LunarCalculator.galacticCenterApex
        case .galacticCenterSet:
            return LunarCalculator.galacticCenterSet
        }
    }

    public static let solarEvents: [SolunarEventKind] = [
        .astronomicalDawnStart,
        .astronomicalDawnEnd,
        .nauticalDawnStart,
        .nauticalDawnEnd,
        .civilDawnStart,
        .blueHourDawnStart,
        .blueHourDawnEnd,
        .goldenHourDawnStart,
        .civilDawnEnd,
        .sunrise,
        .goldenHourDawnEnd,
        .solarNoon,
        .goldenHourDuskStart,
        .sunset,
        .goldenHourDuskEnd,
        .blueHourDuskStart,
        .civilDuskStart,
        .civilDuskEnd,
        .blueHourDuskEnd,
        .nauticalDuskStart,
        .nauticalDuskEnd,
        .astronomicalDuskStart,
        .astronomicalDuskEnd
    ]

    public static let lunarEvents: [SolunarEventKind] = [
        .moonrise,
        .moonApex,
        .moonset,
        .galacticCenterRise,
        .galacticCenterApex,
        .galacticCenterSet
    ]
}
