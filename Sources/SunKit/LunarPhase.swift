import Foundation
import SwiftAA

public enum LunarPhase: String, CaseIterable, Sendable, Codable {
    case new = "New Moon"
    case waningCrescent = "Waning Crescent"
    case thirdQuarter = "Third Quarter"
    case waningGibbous = "Waning Gibbous"
    case full = "Full Moon"
    case waxingGibbous = "Waxing Gibbous"
    case firstQuarter = "First Quarter"
    case waxingCrescent = "Waxing Crescent"
    
    /// Calculates the current lunar phase based on proximity to exact phase moments
    /// - Parameter julianDay: The Julian Day to calculate the phase for
    /// - Returns: The lunar phase at the given time
    ///
    /// Phase windows:
    /// - New Moon & Full Moon: within ±2% of synodic month from exact moment
    /// - First Quarter & Third Quarter: within ±5% of synodic month from exact moment
    /// - Otherwise: waxing/waning crescent or gibbous based on position in cycle
    public static func current(julianDay: JulianDay) -> LunarPhase {
        // The synodic month (Moon cycle) is 29.53058867 days
        let synodicMonth = 29.53058867

        // Get all four phase times, looking backwards to ensure we get the most recent cycle
        let searchMoon = Moon(julianDay: julianDay - 15)
        
        let newMoonTime = searchMoon.time(of: .newMoon, mean: false)
        let firstQuarterTime = searchMoon.time(of: .firstQuarter, mean: false)
        let fullMoonTime = searchMoon.time(of: .fullMoon, mean: false)
        let lastQuarterTime = searchMoon.time(of: .lastQuarter, mean: false)
        
        // Calculate distances to each phase
        let newDistance = abs(julianDay.value - newMoonTime.value)
        let firstDistance = abs(julianDay.value - firstQuarterTime.value)
        let fullDistance = abs(julianDay.value - fullMoonTime.value)
        let lastDistance = abs(julianDay.value - lastQuarterTime.value)
        
        // Check if within phase windows
        let majorThreshold = synodicMonth * 0.02  // ±2% for new and full
        let quarterThreshold = synodicMonth * 0.05  // ±5% for quarters
        
        if newDistance <= majorThreshold {
            return .new
        }
        if fullDistance <= majorThreshold {
            return .full
        }
        if firstDistance <= quarterThreshold {
            return .firstQuarter
        }
        if lastDistance <= quarterThreshold {
            return .thirdQuarter
        }
        
        // Not in a major phase window, determine crescent vs gibbous
        // Determine position in lunar cycle based on which phase was most recent
        
        // Create array of phases with their times
        let phases: [(phase: LunarPhase, time: Double)] = [
            (.new, newMoonTime.value),
            (.firstQuarter, firstQuarterTime.value),
            (.full, fullMoonTime.value),
            (.thirdQuarter, lastQuarterTime.value)
        ]
        
        // Find the most recent phase before current time
        let pastPhases = phases.filter { $0.time <= julianDay.value }
        guard let mostRecentPhase = pastPhases.max(by: { $0.time < $1.time }) else {
            // If no past phases, we must be before new moon
            return .waningCrescent
        }
        
        // Determine phase based on what came before
        switch mostRecentPhase.phase {
        case .new:
            return .waxingCrescent
        case .firstQuarter:
            return .waxingGibbous
        case .full:
            return .waningGibbous
        case .thirdQuarter:
            return .waningCrescent
        default:
            return .waxingCrescent
        }
    }
}
