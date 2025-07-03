//
//  SolarEventSpec.swift
//  SunKit
//
//  Created by Jim Newkirk on 4/17/25.
//

import Foundation
import SwiftAA

public struct SolarEvent: Sendable {
    internal let angle: Measurement<UnitAngle>
    internal let riseSet: RiseSetEnum

    internal static let goldenHour = Measurement<UnitAngle>(value: 6.0, unit: .degrees)
    internal static let official = Measurement<UnitAngle>(value: TwilightSunAltitude.upperLimbOnHorizonWithRefraction.rawValue.value, unit: .degrees)
    internal static let blueHour = Measurement<UnitAngle>(value: -4.0, unit: .degrees)
    internal static let civil = Measurement<UnitAngle>(value: TwilightSunAltitude.civilian.rawValue.value, unit: .degrees)
    internal static let nautical = Measurement<UnitAngle>(value: TwilightSunAltitude.nautical.rawValue.value, unit: .degrees)
    internal static let astronomical = Measurement<UnitAngle>(value: TwilightSunAltitude.astronomical.rawValue.value, unit: .degrees)

    /// This marks the sunrise, when the sun is 0.833 degrees below the horizon and rising
    public static let sunrise = SolarEvent(angle: Self.official, riseSet: .rise)

    /// This marks the sunset, when the sun is 0.833 degrees below the horizing and setting
    public static let sunset = SolarEvent(angle: Self.official, riseSet: .set)

    /// This marks civil dawn, when the sun is 6.0 degrees below the horizon
    public static let civilDawn = SolarEvent(angle: Self.civil, riseSet: .rise)

    /// This marks civil dusk, when the sun is 6.0 degrees below the horizon
    public static let civilDusk = SolarEvent(angle: Self.civil, riseSet: .set)

    /// This marks nautical dawn, when the sun is 12.0 degrees below the horizon
    public static let nauticalDawn = SolarEvent(angle: Self.nautical, riseSet: .rise)

    /// This marks nautical dusk, when the sun is 12.0 degrees below the horizon
    public static let nauticalDusk = SolarEvent(angle: Self.nautical, riseSet: .set)

    /// This marks astronomical dawn, when the sun is 18.0 degrees below the horizon
    public static let astronomicalDawn = SolarEvent(angle: Self.astronomical, riseSet: .rise)

    /// This marks astronomical dusk, when the sun is 18.0 degrees below the horizon
    public static let astronomicalDusk = SolarEvent(angle: Self.astronomical, riseSet: .set)

    /// This marks the end of the blue hour for dawn (which started at civil dawn), when the sun is at 4.0 degrees below the horizon
    public static let blueHourEndDawn = SolarEvent(angle: Self.blueHour, riseSet: .rise)

    /// This marks the start of the blue hour for dusk (which ends at civil dusk), when the sun is at 4.0 degrees below the horizon
    public static let blueHourStartDusk = SolarEvent(angle: Self.blueHour, riseSet: .set)

    /// This marks the end of the golden hour for dawn (which started at blue hour for dawn), when the sun is 6.0 degrees above the horizon
    public static let goldenHourEndDawn = SolarEvent(angle: Self.goldenHour, riseSet: .rise)

    /// This marks the start of the golden hour for dusk (which ends at blue hour for dusk), when the sun is 6.0 degrees above the horizon
    public static let goldenHourStartDusk = SolarEvent(angle: Self.goldenHour, riseSet: .set)

    public static func rise(degrees: Double) -> SolarEvent {
        return SolarEvent(angle: Measurement<UnitAngle>(value: degrees, unit: .degrees), riseSet: .rise)
    }

    public static func rise(angle: Measurement<UnitAngle>) -> SolarEvent {
        return SolarEvent(angle: angle, riseSet: .rise)
    }

    public static func set(degrees: Double) -> SolarEvent {
        return SolarEvent(angle: Measurement<UnitAngle>(value: degrees, unit: .degrees), riseSet: .set)
    }

    public static func set(angle: Measurement<UnitAngle>) -> SolarEvent {
        return SolarEvent(angle: angle, riseSet: .set)
    }
}
